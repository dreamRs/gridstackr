
// From Friss tuto (https://github.com/FrissAnalytics/shinyJsTutorials/blob/master/tutorials/tutorial_03.Rmd)
export function getWidget(id) {
  var htmlWidgetsObj = HTMLWidgets.find("#" + id);
  var widgetObj;
  if (typeof htmlWidgetsObj !== "undefined") {
    widgetObj = htmlWidgetsObj.getWidget();
  }
  return widgetObj;
}
