import http from 'k6/http';
import { check } from 'k6';

export let options = {
  vus: 20,
  duration: '30s',
};

const hosts = ['foo.localhost', 'bar.localhost'];

export default function () {
  const host = hosts[Math.floor(Math.random() * hosts.length)];
  const res = http.get('http://localhost', {
    headers: { Host: host },
  });

  check(res, {
    'status is 200': r => r.status === 200,
  });
}