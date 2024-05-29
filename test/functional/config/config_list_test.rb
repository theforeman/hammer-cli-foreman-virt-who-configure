# frozen_string_literal: true

require_relative '../test_helper'

describe 'virt-who-config' do
  describe 'list' do
    before do
      @cmd = ['virt-who-config', 'list']
    end

    it 'formats interval and status' do
      configs = [
        config,
        config('status' => 'ok', 'interval' => 120),
        config('status' => 'out_of_date', 'interval' => 240),
        config('status' => 'error', 'interval' => 480)
      ]

      api_expects(:configs, :index).returns(index_response(configs))

      output = IndexMatcher.new([
        ['ID', 'NAME', 'INTERVAL',      'STATUS',        'LAST REPORT AT'],
        ['11', 'test', 'every hour',    'No Report Yet', ''],
        ['11', 'test', 'every 2 hours', 'OK',            ''],
        ['11', 'test', 'every 4 hours', 'OK',            ''],
        ['11', 'test', 'every 8 hours', 'Error',         '']
      ])

      result = run_cmd(@cmd)
      assert_cmd(success_result(output), result)
    end

    it 'supports pagination' do
      params = ['--page=2', '--per-page=10', '--order', 'name ASC']

      api_expects(:configs, :index).with_params(
        'page' => 2,
        'per_page' => '10',
        'order' => 'name ASC'
      ).returns(index_response([]))

      result = run_cmd(@cmd + params)
      assert_cmd(success_result(/.*/), result)
    end

    it 'supports search' do
      params = ['--search', 'name ~ test']

      api_expects(:configs, :index).with_params('search' => 'name ~ test').returns(index_response([]))

      result = run_cmd(@cmd + params)
      assert_cmd(success_result(/.*/), result)
    end
  end
end
