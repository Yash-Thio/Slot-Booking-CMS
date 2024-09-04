'use strict';

/**
 * slide-show service
 */

const { createCoreService } = require('@strapi/strapi').factories;

module.exports = createCoreService('api::slide-show.slide-show');
