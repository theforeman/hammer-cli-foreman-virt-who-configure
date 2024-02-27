require_relative '../test_helper'

describe "virt-who-config" do
  describe "create" do
    before do
      @cmd = ["virt-who-config", "create"]
      @required_args = {
        :name => 'test',
        :interval => 60,
        :filtering_mode => 'whitelist',
        :hypervisor_id => 'uuid',
        :hypervisor_type => 'libvirt',
        :hypervisor_server => 1,
        :hypervisor_username => 1,
        :satellite_url => 1,
        :organization_id => 1
      }
    end

    it "requires --name" do
      params = hash_to_opts(@required_args, :reject => :name)
      assert_requires_argument(@cmd, params, 'name')
    end

    it "requires --interval" do
      params = hash_to_opts(@required_args, :reject => :interval)
      assert_requires_argument(@cmd, params, 'interval')
    end

    it "requires --filtering-mode" do
      params = hash_to_opts(@required_args, :reject => :filtering_mode)
      assert_requires_argument(@cmd, params, 'filtering-mode')
    end

    it "requires --hypervisor-id" do
      params = hash_to_opts(@required_args, :reject => :hypervisor_id)
      assert_requires_argument(@cmd, params, 'hypervisor-id')
    end

    it "validates --hypervisor-id values" do
      params = hash_to_opts(@required_args.merge(:hypervisor_id => 'other'))
      assert_usage_error(@cmd, params, "Option '--hypervisor-id': Value must be one of 'hostname', 'uuid', 'hwuuid'..")
    end

    it "requires --hypervisor-type" do
      params = hash_to_opts(@required_args, :reject => :hypervisor_type)
      assert_requires_argument(@cmd, params, 'hypervisor-type')
    end

    it "validates --hypervisor-type values" do
      params = hash_to_opts(@required_args.merge(:hypervisor_type => 'other'))
      assert_usage_error(@cmd, params, "Option '--hypervisor-type': Value must be one of 'esx', 'hyperv', 'libvirt', 'kubevirt', 'ahv'..")
    end

    it "requires --satellite-url" do
      params = hash_to_opts(@required_args, :reject => :satellite_url)
      assert_requires_argument(@cmd, params, 'satellite-url')
    end

    it "sends values to api" do
      params = hash_to_opts(@required_args)

      expected_result = success_result("Virt Who configuration [test] created\n")

      api_expects(:configs, :create, 'Create configuration').with_params(
        'foreman_virt_who_configure_config' => {
          'name' => 'test',
          'interval' => '60',
          'filtering_mode' => 1,
          'hypervisor_id' => 'uuid',
          'hypervisor_type' => 'libvirt',
          'hypervisor_server' => '1',
          'hypervisor_username' => '1',
          'satellite_url' => '1',
          'organization_id' => 1
        }
      ).returns(:config => { :name => 'test'})

      result = run_cmd(@cmd + params)
      assert_cmd(expected_result, result)
    end
  end
end
