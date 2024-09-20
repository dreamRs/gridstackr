import "widgets";
import "gridstack/dist/gridstack.min.css";
import "gridstack/dist/gridstack-extra.min.css";
import { GridStack } from "gridstack";
import "../css/custom.css";
import * as utils from "../modules/utils";

HTMLWidgets.widget({

  name: "gridstack",

  type: "output",

  factory: function(el, width, height) {

    var grid;

    return {

      renderValue: function(x) {

        el.classList.add("grid-stack");
        el.classList.add("grid-stack-edit");
        el.style.background = x.bg;
        el.innerHTML = x.html;

        grid = GridStack.init(x.options, el);
        grid.on("resizestop", function(event, el) {
          window.dispatchEvent(new Event("resize"));
        });
        if (HTMLWidgets.shinyMode) {
          var $all = $(el);
          Shiny.bindAll($all);
        }
        grid.on("added", function(event, items) {
          if (HTMLWidgets.shinyMode) {
            items.forEach(function(item) {
              var $item = $(item);
              Shiny.bindAll($item);
            });
          }
        });

        if (HTMLWidgets.shinyMode) {
          var serializedFull = grid.save(true, true);
          Shiny.setInputValue(el.id + "_layout", serializedFull);
          grid.on("added removed change", function(event, items) {
            serializedFull = grid.save(true, true);
            Shiny.setInputValue(el.id + "_layout", serializedFull);
          });
        }

      },

      getWidget: function() {
        return grid;
      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});


if (HTMLWidgets.shinyMode) {

  // add a widget
  Shiny.addCustomMessageHandler("gridstackr-add-widget", function(obj) {
    var grid = utils.getWidget(obj.id);
    if (typeof grid != "undefined") {
      grid.addWidget(obj.data.options);
    }
  });

  // compact layout
  Shiny.addCustomMessageHandler("gridstackr-compact", function(obj) {
    var grid = utils.getWidget(obj.id);
    if (typeof grid != "undefined") {
      grid.compact(obj.data);
    }
  });

  // disable
  Shiny.addCustomMessageHandler("gridstackr-disable", function(obj) {
    var grid = utils.getWidget(obj.id);
    if (typeof grid != "undefined") {
      grid.disable();
    }
  });

  // enable
  Shiny.addCustomMessageHandler("gridstackr-enable", function(obj) {
    var grid = utils.getWidget(obj.id);
    if (typeof grid != "undefined") {
      grid.enable();
    }
  });

  // enableMove
  Shiny.addCustomMessageHandler("gridstackr-enable-move", function(obj) {
    var grid = utils.getWidget(obj.id);
    if (typeof grid != "undefined") {
      grid.enableMove(obj.data.doEnable);
    }
  });

  // enableResize
  Shiny.addCustomMessageHandler("gridstackr-enable-resize", function(obj) {
    var grid = utils.getWidget(obj.id);
    if (typeof grid != "undefined") {
      grid.enableResize(obj.data.doEnable);
    }
  });

  // removeAll
  Shiny.addCustomMessageHandler("gridstackr-remove-all", function(obj) {
    var grid = utils.getWidget(obj.id);
    if (typeof grid != "undefined") {
      grid.removeAll();
    }
  });

  // removeWidget
  Shiny.addCustomMessageHandler("gridstackr-remove-widget", function(obj) {
    var grid = utils.getWidget(obj.id);
    if (typeof grid != "undefined") {
      var container = document.getElementById(obj.id);
      var el = container.querySelector("div[gs-id='" + obj.data.id + "']");
      grid.removeWidget(el)
    }
  });

}



