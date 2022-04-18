#!/usr/bin/env python
import argparse
from asyncore import write
import json
import logging
import os
import time

from influxdb_client import InfluxDBClient, Point
from influxdb_client.client.write_api import SYNCHRONOUS


def influxdb_from_samples_data(game_data, samples_data, client, args):
    write_api = client.write_api(write_options=SYNCHRONOUS)
    points = []
    logging.debug(f'writing data for {len(samples_data["entities"])} entities')

    if 'ticks' in samples_data:
        logging.debug(f'ticks: {samples_data["ticks"]}')
        ticks = round(samples_data["ticks"] / 60.0)
    else:
        ticks = None
    for entity in samples_data['entities']:
        settings = entity['settings']
        if not settings['name']:
            logging.debug('unnamed combinator, skipping')
            continue
        logging.debug(f'writing data for {settings["name"]}')

        tags = {pair.split('=')[0]: pair.split('=')[1] for pair in settings['tags'].split(',')}
        tags['combinator'] = settings['name']
        if 'surface_index' in entity:
            tags['surface_index'] = entity['surface_index']
        if 'unit_number' in entity:
            tags['unit_number'] = entity['unit_number']

        for signal in entity.get('red_signals', []):

            p = Point(signal['signal']['name']).tag('circuit', 'red').tag('type', signal['signal']['type'])
            for key, tag in tags.items():
                p.tag(key, tag)
            p.field('count', signal['count'])
            if ticks is not None:
                p.time(ticks)
            points.append(p)
            logging.debug(f'writing red {signal["signal"]["name"]} for {signal["count"]}')

        for signal in entity.get('green_signals', []):
            p = Point(signal['signal']['name']).tag('circuit', 'green').tag('type', signal['signal']['type'])
            for key, tag in tags.items():
                p.tag(key, tag)

            p.field('count', signal['count'])
            if ticks is not None:
                p.time(ticks)
            points.append(p)
            logging.debug(f'writing green {signal["signal"]["name"]} for {signal["count"]}')

    write_api.write(bucket=args.influxdb_bucket, record=points)


if __name__ == '__main__':
    default_script_output = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))), 'script-output')

    parser = argparse.ArgumentParser(description='forwards metrics from factorio to influxdb')
    parser.add_argument('--factorio-script-output', type=str, default=default_script_output, help=f'the path to factorio\'s script-output directory (default: {default_script_output})')
    parser.add_argument('--influxdb-port', type=int, default=8086, help='the port that influxdb is listening on (default: 8086)')
    parser.add_argument('--influxdb-host', type=str, default='127.0.0.1', help='the host where influxdb is listening (default: 127.0.0.1)')
    parser.add_argument('--influxdb-org', type=str, help='the organization to use for influxdb reads and writes')
    parser.add_argument('--influxdb-token', type=str, help='the token for auth')
    parser.add_argument('--influxdb-bucket', type=str, default='factorio', help='the bucket to write to')
    args = parser.parse_args()

    logging.basicConfig(level=logging.DEBUG)

    if not os.path.exists(os.path.dirname(args.factorio_script_output)):
        logging.critical(f'factorio not found at {args.factorio_script_output}. please check --factorio-script-output')

    logging.info(f'forwarding data from {args.factorio_script_output}')

    data_path = os.path.join(args.factorio_script_output, 'factorystatsd-game-data.json')
    samples_path = os.path.join(args.factorio_script_output, 'factorystatsd-samples.json')

    last_game_data_mod_time = 0
    game_data = None

    while True:
        try:
            client = InfluxDBClient(
                url=f'http://{args.influxdb_host}:{args.influxdb_port}',
                token=args.influxdb_token,
                org=args.influxdb_org
            )
            if not os.path.exists(data_path):
                logging.debug('No game data yet')
                time.sleep(1.0)
                continue

            game_data_mod_time = os.path.getmtime(data_path)
            if game_data is None or game_data_mod_time > last_game_data_mod_time:
                with open(data_path) as f:
                    game_data = json.load(f)
                logging.info('loaded game data')
            last_game_data_mod_time = game_data_mod_time

            if not os.path.exists(samples_path):
                logging.debug('No samples data yet')
                time.sleep(0.1)
                continue

            with open(samples_path) as f:
                samples = json.load(f)
                logging.info('loaded samples data')
            os.unlink(samples_path)

            influxdb_from_samples_data(game_data, samples, client, args)
        except Exception as e:
            logging.exception(f'forwarder exception: {e}')
            time.sleep(1.0)
