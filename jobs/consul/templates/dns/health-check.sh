#!/bin/bash
<%
    require "shellwords"
    def esc(x)
        Shellwords.shellescape(x)
    end

    if p("server")

        if p("tls.enabled")
            api_scheme = "https"
            api_port = 8501
        else
            api_scheme = "http"
            api_port = 8500
        end

        if p("ui.enabled")
            uri = "/ui/"
        else
            uri = "/v1/agent/metrics"
        end
-%>

exec curl --silent --fail --show-error --location \
    --resolve <%= esc("#{spec.address}:#{api_port}:127.0.0.1") %> \
    --cacert "/var/vcap/jobs/consul/tls/consul-ca-bundle.crt" \
    --cert "/var/vcap/jobs/consul/tls/agent.crt" \
    --key "/var/vcap/jobs/consul/tls/agent.key" \
    --url <%= esc("#{api_scheme}://#{spec.address}:#{api_port}#{uri}") %> \
    --output /dev/null
<%
    end # if p("server")
-%>
