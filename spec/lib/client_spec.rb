require 'spec_helper'

describe ScriptoriaCore::Client do
  before do
    subject.configure('http://core.dev/')
  end

  subject {
    described_class
  }

  context "::ping" do
    before do
      stub_request(:GET, "http://core.dev/v1/ping").
        to_return(body: '{"ping":"pong"}', status: 200)
    end

    describe "request" do
      it "makes a ping request" do
        subject.ping
        expect(WebMock).to have_requested(:GET, "http://core.dev/v1/ping").once
      end
    end

    describe "response" do
      it "returns nil on success" do
        expect(subject.ping).to be_nil
      end

      xit "raises PingError when the response body is invalid" do
        WebMock.reset!
        stub_request(:GET, "http://core.dev/v1/ping").
          to_return(body: 'Hello world!', status: 200)

        expect {
          subject.ping
        }.to raise_error(ScriptoriaCore::Client::PingError)
      end

      xit "raises PingError when the response status is invalid" do
        WebMock.reset!
        stub_request(:GET, "http://core.dev/v1/ping").
          to_return(body: 'Bad Request', status: 400)

        expect {
          subject.ping
        }.to raise_error(ScriptoriaCore::Client::PingError)
      end
    end
  end

  context "::start!" do
    before do
      stub_request(:POST, "http://core.dev/v1/workflows").
        to_return(body: '{"id":"20151005-1247-kogadeso-gekunute"}', status: 201)
    end

    describe "request body" do
      it "generates a request body with a callback" do
        subject.start!("workflow", "http://example.com")

        expect(WebMock).to have_requested(:POST, "http://core.dev/v1/workflows").
          with(body: 'callback=http%3A%2F%2Fexample.com&workflow=workflow')
      end

      it "generates a request body with a callbacks" do
        subject.start!("workflow", { a: "http://example1.com", b: "http://example2.com/" })

        expect(WebMock).to have_requested(:POST, "http://core.dev/v1/workflows").
          with(body: 'callbacks%5Ba%5D=http%3A%2F%2Fexample1.com&callbacks%5Bb%5D=http%3A%2F%2Fexample2.com%2F&workflow=workflow')
      end

      it "generates a request body with a params" do
        subject.start!("workflow", "http://example.com", { a: 1, b: 2 })

        expect(WebMock).to have_requested(:POST, "http://core.dev/v1/workflows").
          with(body: 'callback=http%3A%2F%2Fexample.com&fields%5Ba%5D=1&fields%5Bb%5D=2&workflow=workflow')
      end
    end

    describe "response" do
      it "returns the workflow id" do
        expect(subject.start!("workflow", "http://example.com")).to eq "20151005-1247-kogadeso-gekunute"
      end

      it "raises an error when the response body is invalid" do
        stub_request(:POST, "http://core.dev/v1/workflows").
          to_return(body: 'Hello world', status: 201)

        expect {
          subject.start!("workflow", "http://example.com")
        }.to raise_error # TODO specify error
      end

      xit "raises an error when the response status is invalid" do
        stub_request(:POST, "http://core.dev/v1/workflows").
          to_return(body: '{"id":"20151005-1247-kogadeso-gekunute"}', status: 200)

        expect {
          subject.start!("workflow", "http://example.com")
        }.to raise_error # TODO specify error
      end
    end
  end

  context "::cancel!" do
    before do
      stub_request(:POST, "http://core.dev/v1/workflows/1234/cancel").
        to_return(body: 'null', status: 201)
    end

    describe "request" do
      it "makes a cancel request" do
        subject.cancel!(1234)
        expect(WebMock).to have_requested(:POST, "http://core.dev/v1/workflows/1234/cancel").once
      end
    end

    describe "response" do
      it "returns nil" do
        expect(subject.cancel!(1234)).to be_nil
      end

      xit "raises an error when the response status is invalid" do
        stub_request(:POST, "http://core.dev/v1/workflows/1234/cancel").
          to_return(body: 'null', status: 200)

        expect {
          subject.cancel!(1234)
        }.to raise_error # TODO specify error
      end
    end
  end

  context "::proceed!" do
    before do
      stub_request(:POST, "http://core.dev/v1/workflows/1234/workitems/5678/proceed").
        to_return(body: 'null', status: 201)
    end

    describe "request" do
      it "generates a request body without fields" do
        subject.proceed!("http://core.dev/v1/workflows/1234/workitems/5678/proceed", {})
        expect(WebMock).to have_requested(:POST, "http://core.dev/v1/workflows/1234/workitems/5678/proceed").
          with(body: nil)
      end

      it "generates a request body with fields" do
        subject.proceed!("http://core.dev/v1/workflows/1234/workitems/5678/proceed", { a: true })
        expect(WebMock).to have_requested(:POST, "http://core.dev/v1/workflows/1234/workitems/5678/proceed").
          with(body: 'fields%5Ba%5D=true')
      end
    end

    describe "response" do
      it "returns nil" do
        expect(subject.proceed!("http://core.dev/v1/workflows/1234/workitems/5678/proceed", {})).to be_nil
      end

      xit "raises an error when the response status is invalid" do
        stub_request(:POST, "http://core.dev/v1/workflows/1234/workitems/5678/proceed").
          to_return(body: 'null', status: 200)

        expect {
          subject.proceed!("http://core.dev/v1/workflows/1234/workitems/5678/proceed", {})
        }.to raise_error # TODO specify error
      end
    end
  end
end
