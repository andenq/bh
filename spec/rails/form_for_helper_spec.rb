require 'rails_helper'
require 'bh/core_ext/rails/form_for_helper'
include Bh::Rails::Helpers

describe 'form_for' do
  let(:bh) { RailsView.new }
  let(:protect_against_forgery?) { false }
  attr_accessor :output_buffer
  let(:form) { form_for(:object, options.merge(url: '/')) {} }
  let(:options) { {} }

  specify 'by default, does not apply Bootstrap attributes to the form' do
    expect(form).not_to include 'role="form"'
  end

  specify 'wrapped in navbar, applies Bootstrap attributes of a navbar form' do
    bh.navbar { expect(form).to include 'role="form"' }
    bh.navbar { expect(form).to include 'class="navbar-form"' }
  end

  specify 'wrapped in nav, surrounds the form in a <li> item' do
    bh.nav { expect(form).to match %r{^<li><form.+?</form></li>$} }
  end

  describe 'with layout: :horizontal' do
    let(:options) { {layout: :horizontal} }

    specify 'applies Bootstrap attributes of an horizontal form' do
      expect(form).to include 'role="form"'
      expect(form).to include 'class="form-horizontal"'
    end
  end

  describe 'with layout: :inline' do
    let(:options) { {layout: :inline} }

    specify 'applies Bootstrap attributes of an inline form' do
      expect(form).to include 'role="form"'
      expect(form).to include 'class="form-inline"'
    end
  end

  describe 'with any other value for :layout' do
    let(:options) { {layout: :basic} }

    specify 'applies Bootstrap attributes of a basic form' do
      expect(form).to include 'role="form"'
    end
  end

  describe 'form_builder option' do
    specify 'by default is true' do
      expect(Bh.form_builder).to eq(true)
    end

    specify 'when true, uses FormBuilder' do
      form_for(:object, options.merge(url: '/', layout: :wat)) do |f|
        expect(f.is_a?(Bh::FormBuilder)).to eq(true)
      end
    end

    specify 'when false, does not use FormBuilder' do
      begin
        Bh.form_builder = false
        form_for(:object, options.merge(url: '/', layout: :wat)) do |f|
          expect(f.is_a?(ActionView::Helpers::FormBuilder)).to eq(true)
          expect(f.is_a?(Bh::FormBuilder)).to eq(false)
        end
      ensure
        Bh.form_builder = true
      end
    end
  end
end