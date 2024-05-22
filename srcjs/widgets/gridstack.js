import "widgets";
import "gridstack/dist/gridstack.min.css";
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
        el.innerHTML = x.html;

        grid = GridStack.init(x.options, el);
        grid.on("resizestop", function(event, el) {
          window.dispatchEvent(new Event("resize"));
        });

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
    console.log(obj);
    var grid = utils.getWidget(obj.id);
    if (typeof grid != "undefined") {
      console.log(grid);
      grid.addWidget(obj.options);
    }
  });

}



