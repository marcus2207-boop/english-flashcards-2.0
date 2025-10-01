import http from 'k6/http';
import { check, sleep } from 'k6';
import { Trend } from 'k6/metrics';

export let options = {
  vus: 20,
  duration: '30s',
  thresholds: {
    'http_req_duration': ['p(90)<300'] // p90 < 300ms
  }
};

const BASE = __ENV.BASE_URL || 'http://localhost:8000';

let dashboardTrend = new Trend('dashboard_req_duration');

export default function () {
  // Simulate an authenticated request by using a test token / or anonymous public data endpoint.
  // Adjust to use real auth cookie header if available in CI.
  let res = http.get(`${BASE}/api/users/1/lessons`);
  dashboardTrend.add(res.timings.duration);
  check(res, {
    'status is 200': (r) => r.status === 200,
  });
  sleep(1);
}