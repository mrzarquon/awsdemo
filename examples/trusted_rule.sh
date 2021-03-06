PATH="/opt/puppetlabs/bin:/opt/puppetlabs/puppet/bin:/opt/puppet/bin:$PATH"

curl -X POST -H 'Content-Type: application/json' \
-d \
'{
    "name": "WebServer",
    "environment": "production",
    "parent": "00000000-0000-4000-8000-000000000000",
    "rule": [
        "=",
        [
            "trusted",
            "extensions",
            "pp_role"
        ],
        "webserver"
    ],
    "classes": {
        "ntp": {}
    },
    "variables": {}
}' \
--cacert `puppet agent --configprint localcacert` --cert `puppet agent --configprint hostcert` --key `puppet agent --configprint hostprivkey` --insecure https://localhost:4433/classifier-api/v1/groups | python -m json.tool
