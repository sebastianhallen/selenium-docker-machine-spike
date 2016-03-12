'use strict';

const seleniumServer = 'http://' + (process.env.DOCKER_MACHINE_IP || '0.0.0.0') + ':4444/wd/hub';
const webdriver = require('selenium-webdriver');
const request = require('request-promise');
const by = webdriver.By;
const until = webdriver.until;

function waitPromise(milliseconds, state) {
  return new Promise(resolve => {
    setTimeout(() => {
      resolve(state);
    }, milliseconds);
  });
}

function awaitSelenium(retries) {
  if (typeof retries !== 'number') {
    retries = 10;
  }
  
  if (retries < 0) {
    throw new Error('timed out waiting for selenium server');
  }
  
  return Promise.all([request(seleniumServer)
    .then(() => console.log('selenium hub up n running @ ' + seleniumServer))
    .catch(error => {
      console.log(error);
      return waitPromise(1000).then(() => awaitSelenium(--retries));
    })]);
}

awaitSelenium().then(() => {
  console.log('starting tests');

  const driver = new webdriver.Builder()
    .forBrowser('chrome')
    .usingServer(seleniumServer)
    .build();
    
  driver.get('http://www.google.com/ncr');
  driver.findElement(by.name('q')).sendKeys('webdriver');
  driver.findElement(by.name('btnG')).click();
  driver.wait(until.titleIs('webdriver - Google Search'), 1000);
  driver.quit();
});
