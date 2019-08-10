#!/usr/bin/bash

sleep 50

echo "Getting grafana password save to grafana_pass.txt file."
kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode >/vagrant/grafana_pass.txt

echo "Getting grafana URL in grafana_url.txt."

IP=$(ip a s | grep eth1 | grep inet | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | grep -v 255)

GRAFANA_PORT=$(kubectl get svc -n monitoring | grep grafana | awk '{print $5}' | awk -F ":" '{print $2}' | sed -e 's/\/TCP//')

echo "http://${IP}:${GRAFANA_PORT}" >/vagrant/grafana_url.txt

echo "Getting url for dashboard in dashboard_url.txt"
DASHBOARD_PORT=$(kubectl get svc -n kube-system | grep dashboard | awk '{print $5}' | awk -F ":" '{print $2}' | sed -e 's/\/TCP//')

echo "https://${IP}:${DASHBOARD_PORT}" >/vagrant/dashboard_url.txt

echo "Get Dashbord Secret tocken in dash_secret_token.txt for login."

TOKEN=$(kubectl describe secret -n kube-system $(kubectl get secret -n kube-system | grep dashboard-token | awk '{print $1}') | grep "^token" | sed -e 's/token:\s*//')

echo ${TOKEN} >/vagrant/dash_secret_token.txt

echo "Get Datasource for prometheus"
PROMETHEUS_DATA_SOURCE=$(kubectl get svc -n monitoring | grep prometheus-server | awk '{print "http://"$3":"$5}' | sed -e 's/\/TCP//')

echo ${PROMETHEUS_DATA_SOURCE} >/vagrant/prometheus_data_source.txt

echo "Getting url for guestbook in guestbook_url.txt"
GUESTBOOK_URL=$(kubectl get svc -n deployment | grep frontend | awk '{print $5}' | awk -F ":" '{print $2}' | sed -e 's/\/TCP//')

echo "http://${IP}:${GUESTBOOK_URL}" >/vagrant/guestbook_url.txt
