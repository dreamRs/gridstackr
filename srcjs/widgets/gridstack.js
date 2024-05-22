import "widgets";
import "gridstack/dist/gridstack.min.css";
import { GridStack } from "gridstack";
import "../css/custom.css";

HTMLWidgets.widget({

  name: "gridstack",

  type: "output",

  factory: function(el, width, height) {

    return {

      renderValue: function(x) {

        el.classList.add("grid-stack");
        el.classList.add("grid-stack-edit");
        el.innerHTML = x.html;

        var grid = GridStack.init(x.options, el);
        grid.on("resizestop", function(event, el) {
          window.dispatchEvent(new Event("resize"));
        });

      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});
