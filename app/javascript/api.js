/**
 * Contains definitions of front-end API endpoints
 */

const axios = require('axios');

axios.defaults.baseURL = '/api/v1';

export default {
  // Example endpoint
  example: {
    // Post to api/v1/example, providing the name
    post: (name) => axios.post('/example',
        {name: name})
  }
}