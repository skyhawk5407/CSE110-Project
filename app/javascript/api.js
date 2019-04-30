/**
 * Contains definitions of front-end API endpoints
 */

const axios = require('axios');

axios.defaults.baseURL = '/api/v1';

export default {
  endpoint: {
    get: (value1) => axios.get('/endpoint', {params: {key1: value1}}),
    post: (password, value1) => axios.post('/endpoint',
        {key1: value1},
        {headers: {Authorization: password}})
  }
}