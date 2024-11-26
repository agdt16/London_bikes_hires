window.LeafletWidget.methods.setStyle = function(category, layerId, style){
    var map = this;
    if (!layerId){
    return;
    } else if (!(typeof(layerId) === "object" && layerId.length)){ // in case a single layerid is given
    layerId = [layerId];
    }
    
    //convert columnstore to row store
    style = HTMLWidgets.dataframeToD3(style);
    //console.log(style);
    
    layerId.forEach(function(d,i){
    var layer = map.layerManager.getLayer(category, d);
    if (layer){ // or should this raise an error?
    layer.setStyle(style[i]);
    }
    });
    };
    
    window.LeafletWidget.methods.setRadius = function(layerId, radius){
    var map = this;
    if (!layerId){
    return;
    } else if (!(typeof(layerId) === "object" && layerId.length)){ // in case a single layerid is given
    layerId = [layerId];
    radius = [radius];
    }
    
    layerId.forEach(function(d,i){
    var layer = map.layerManager.getLayer("marker", d);
    if (layer){ // or should this raise an error?
    layer.setRadius(radius[i]);
    }
    });
    };