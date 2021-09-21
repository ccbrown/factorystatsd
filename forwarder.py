#!/usr/bin/env python
import argparse
import json
import logging
import os
import socket
import time


def normalize_metric_name(name):
    """
    Makes the name conform to common naming conventions and limitations:

        * The result will start with a letter.
        * The result will only contain alphanumerics, underscores, and periods.
        * The result will be lowercase.
        * The result will not exceed 200 characters.
    """
    if not name[0].isalpha():
        name = 'x' + name
    name = name.lower()
    name = ''.join(['_' if not c.isalnum() and c != '_' and c != '.' else c for c in name])
    return name[:200]


def statsd_lines_from_samples_data(game_data, samples_data, flavor):
    lines = []

    for entity in samples_data['entities']:
        settings = entity['settings']
        if not settings['name']:
            continue
        name = normalize_metric_name(settings['name'])
        gauges = {}

        tags = []
        for kv in settings['tags'].split(','):
            parts = kv.split('=', 1)
            if len(parts) > 1:
                tags.append(parts[0]+':'+parts[1])
            else:
                tags.append(parts[0])

        for signals in [entity.get('red_signals', []), entity.get('green_signals', [])]:
            for signal in signals:
                signal_type_name = signal['signal']['type'] + '.' + signal['signal']['name']
                key = name + '|' + signal_type_name
                gauge = gauges.get(key, None)
                if gauge is None:
                    gauges[key] = {
                        'name': name,
                        'n': signal['count'],
                        'tags': tags + ['signal_type:' + signal['signal']['type'], 'signal_name:' + signal['signal']['name']],
                    }
                else:
                    gauge['n'] += signal['count']

        if settings['absent_signals'] == 'treat-as-0':
            for signal_type, signal_names in [
                ('virtual', game_data['virtual_signal_names']),
                ('item', game_data['item_names']),
                ('fluid', game_data['fluid_names']),
            ]:
                for signal_name in signal_names:
                    signal_type_name = signal_type + '.' + signal_name
                    key = name + '|' + signal_type_name
                    if key not in gauges:
                        gauges[key] = {
                            'name': name,
                            'n': 0,
                            'tags': tags + ['signal_type:' + signal_type, 'signal_name:' + signal_name],
                        }

        if flavor == 'dogstatsd' and tags:
            lines.extend([name + ':' + str(g['n']) + '|g|#' + ','.join(g['tags']) for g in gauges.values()])
        else:
            lines.extend([name + ':' + str(g['n']) + '|g' for g in gauges.values()])

    return lines


def statsd_packets_from_lines(lines, max_size):
    buf = ''
    ret = []
    for line in lines:
        if len(buf) + 1 + len(line) > max_size:
            ret.append(buf.encode('utf-8'))
            buf = ''
        if buf:
            buf += '\n'
        buf += line
    if buf:
        ret.append(buf.encode('utf-8'))
    return ret


if __name__ == '__main__':
    default_script_output = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))), 'script-output')

    parser = argparse.ArgumentParser(description='forwards metrics from factorio to statsd')
    parser.add_argument('--factorio-script-output', type=str, default=default_script_output, help='the path to factorio\'s script-output directory (default: {})'.format(default_script_output))
    parser.add_argument('--statsd-flavor', type=str, choices=['vanilla', 'dogstatsd'], default='vanilla', help='the flavor of statsd to use (note that vanilla statsd does not currently support tags)')
    parser.add_argument('--statsd-port', type=int, default=8125, help='the port that statsd is listening on (default: 8125)')
    parser.add_argument('--statsd-host', type=str, default='127.0.0.1', help='the host where statsd is listening (default: 127.0.0.1)')
    args = parser.parse_args()

    logging.basicConfig(level=logging.INFO)

    if not os.path.exists(os.path.dirname(args.factorio_script_output)):
        logging.critical('factorio not found at script output path. please check --factorio-script-output')

    logging.info('forwarding data from ' + args.factorio_script_output)

    data_path = os.path.join(args.factorio_script_output, 'factorystatsd-game-data.json')
    samples_path = os.path.join(args.factorio_script_output, 'factorystatsd-samples.json')

    last_game_data_mod_time = 0
    game_data = None

    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

    while True:
        try:
            if not os.path.exists(data_path):
                time.sleep(1.0)
                continue

            game_data_mod_time = os.path.getmtime(data_path)
            if game_data is None or game_data_mod_time > last_game_data_mod_time:
                with open(data_path) as f:
                    game_data = json.load(f)
                logging.info('loaded game data')
            last_game_data_mod_time = game_data_mod_time

            if not os.path.exists(samples_path):
                time.sleep(0.1)
                continue

            with open(samples_path) as f:
                samples = json.load(f)
            os.unlink(samples_path)

            statsd_lines = statsd_lines_from_samples_data(game_data, samples, args.statsd_flavor)
            packets = statsd_packets_from_lines(statsd_lines, 1432)
            if packets:
                for packet in packets:
                    sock.sendto(packet, (args.statsd_host, args.statsd_port))
                logging.info('sent {} packets to statsd'.format(len(packets)))
        except Exception:
            logging.exception('forwarder exception')
            time.sleep(1.0)
