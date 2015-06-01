require 'spec_helper'

describe 'springbootmodule' do
  context 'supported operating systems' do
    ['Debian', 'RedHat'].each do |osfamily|
      describe "play class without any parameters on #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily => osfamily,
        }}

        it { should compile.with_all_deps }

        it { should contain_class('springbootmodule::params') }
        it { should contain_class('springbootmodule::install').that_comes_before('play::config') }
        it { should contain_class('springbootmodule::config') }
        it { should contain_class('springbootmodule::service').that_subscribes_to('springbootmodule::config') }

        it { should contain_service('springbootmodule') }
        it { should contain_package('springbootmodule').with_ensure('present') }
      end
    end
  end

  context 'unsupported operating system' do
    describe 'play class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { should contain_package('springbootmodule') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
