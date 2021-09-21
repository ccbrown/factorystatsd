#!/usr/bin/env python
import unittest
from forwarder import *

class TestForwarder(unittest.TestCase):
    def test_statsd_lines_from_samples_data(self):
        lines = statsd_lines_from_samples_data({}, {
            'entities': {},
        }, 'statsd')
        self.assertEqual(lines, [])

        game_data = {
            'virtual_signal_names': ['signal-A'],
            'item_names': ['coal'],
            'fluid_names': ['water'],
        }

        test_samples = {
            'entities': [{
                'settings': {
                    'name': 'my_metric',
                    'tags': 'base=alpha,planet=nauvis,ores',
                    'absent_signals': 'ignore',
                },
                'red_signals': [{
                    'signal': {
                        'type': 'item',
                        'name': 'coal',
                    },
                    'count': 2,
                }],
            }],
        }

        lines = statsd_lines_from_samples_data(game_data, test_samples, 'statsd')
        self.assertEqual(lines, [
            'my_metric:2|g',
        ])

        lines = statsd_lines_from_samples_data(game_data, test_samples, 'dogstatsd')
        self.assertEqual(lines, [
            'my_metric:2|g|#base:alpha,planet:nauvis,ores,signal_type:item,signal_name:coal',
        ])

        test_samples['entities'][0]['settings']['absent_signals'] = 'treat-as-0'
        lines = statsd_lines_from_samples_data(game_data, test_samples, 'dogstatsd')
        self.assertItemsEqual(lines, [
            'my_metric:0|g|#base:alpha,planet:nauvis,ores,signal_type:virtual,signal_name:signal-A',
            'my_metric:2|g|#base:alpha,planet:nauvis,ores,signal_type:item,signal_name:coal',
            'my_metric:0|g|#base:alpha,planet:nauvis,ores,signal_type:fluid,signal_name:water',
        ])


    def test_statsd_packets_from_lines(self):
        packets = statsd_packets_from_lines(['foo', 'bar', 'baz'], 7)
        self.assertEqual(packets, ['foo\nbar', 'baz'])


if __name__ == '__main__':
    unittest.main()
