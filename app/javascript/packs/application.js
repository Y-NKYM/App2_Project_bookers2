// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

import "jquery";
import "popper.js";
import "bootstrap";
import "../stylesheets/application";

//Chart作成
import Chart from "chart.js/auto";
window.weekChart = function(selectId, chart_data){
  new Chart(selectId, {
    type: 'line',
    data: {
      labels: ["６日前","５日前","４日前","３日前","２日前","１日前","今日"],
      datasets: [{
        label: '投稿した本の数',
        data: chart_data,
        tension: 0.5,
        borderColor: '#f88'
      }],
    },
    options: {
      plugins: {
            title: {
              display: true,
              text: "7日間の投稿数の比較"
            }
        },
      y: {
        suggestedMin: 0,
        suggestedMax: 10,
      },
    },
  });
}

// ダウンロードしたRaty.jsをapplication.js内に入れる。
// インスタンスメソッド化＋初期化により、raty()が可能になる。
import Raty from "raty.js"
window.raty = function(elem, opt) {
  let raty = new Raty(elem, opt);
  raty.init();
  return raty;
}

Rails.start()
Turbolinks.start()
ActiveStorage.start()
