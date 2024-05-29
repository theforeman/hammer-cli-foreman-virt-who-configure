# frozen_string_literal: true

require_relative '../test_helper'

describe 'virt-who-config' do
  describe 'update' do
    before do
      @cmd = ['virt-who-config', 'update']
      @update_args = {
        :name => 'test',
        :new_name => 'test2',
        :interval => 60,
        :filtering_mode => 'blacklist',
        :hypervisor_id => 'uuid',
        :hypervisor_type => 'libvirt',
        :hypervisor_server => 1,
        :hypervisor_username => 1,
        :satellite_url => 1,
        :organization_id => 1
      }
    end

    it 'sends values to api' do
      params = hash_to_opts(@update_args)

      expected_result = success_result("Virt Who configuration [test] updated\n")

      api_expects_search(:configs, :name => 'test').returns(index_response([config]))
      api_expects(:configs, :update, 'Create configuration').with_params(
        'id' => 11,
        'foreman_virt_who_configure_config' => {
          'name' => 'test2',
          'interval' => '60',
          'filtering_mode' => 2,
          'hypervisor_id' => 'uuid',
          'hypervisor_type' => 'libvirt',
          'hypervisor_server' => '1',
          'hypervisor_username' => '1',
          'satellite_url' => '1',
          'organization_id' => 1
        }
      ).returns(:config => config)

      result = run_cmd(@cmd + params)
      assert_cmd(expected_result, result)
    end
  end
end
