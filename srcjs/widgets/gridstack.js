import "widgets";
import "gridstack/dist/gridstack.min.css";
import { GridStack } from "gridstack";

HTMLWidgets.widget({

  name: "gridstack",

  type: "output",

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {

      renderValue: function(x) {

        el.classList.add("grid-stack");
        el.innerHTML = x.html;

        var grid = GridStack.init(x.options, el);
        grid.on("resize", function(event, el) {
          window.dispatchEvent(new Event("resize"));
        });

      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});
