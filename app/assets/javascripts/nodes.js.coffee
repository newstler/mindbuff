# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('svg').find('g').attr("transform", "scale(2)")

$.draw_nodes_graph = (path) ->
  graph = Viva.Graph.graph()

  graphics = Viva.Graph.View.svgGraphics()
  nodeSize = 100

  $.getJSON path, (data) ->
    $.each data["nodes"], (i, item) ->
      graph.addNode(item.id, { image: item.image })
    $.each data["nodes"], (i, item) ->
      $.each item.connections, (i, connection) ->
        alert connection.id
        graph.addLink(item.id, connection.id)

  graphics.node((node) ->
    #//ui = Viva.Graph.svg("image").attr("width", nodeSize).attr("height", nodeSize).link(node.data)

    ui = Viva.Graph.svg("g")
    # svgText = Viva.Graph.svg("text").attr("y", nodeSize + 20 + "px").attr("style", "text-anchor: middle;").attr("cursor", "pointer").attr("display", "none").attr("font-size", "21px").text(node.data[1])
    img = Viva.Graph.svg("image").attr("width", nodeSize).attr("height", nodeSize).attr("transform", "translate(-" + nodeSize/2 + ",0)").link(node.data.image)
    # alert node.image
    # ui.append svgText
    ui.append img
    
    $(ui).hover (->
      highlightRelatedNodes node.id, true
    #   ui.children("text")[0].attr("display", "block")
    ), ->
      highlightRelatedNodes node.id, false
    #   ui.children("text")[0].attr("display", "none")

    # $(ui).children("text").hover (->
    #   $(ui).children("text").attr("text-decoration", "underline").attr("fill", "white")
    # ), ->
    #   $(ui).children("text").attr("text-decoration", "none").attr("fill", "black")

    # $(ui).children("text").click -> window.open "/attendees/" + node.id, "_self"

    ui
  ).placeNode (nodeUI, pos) ->
    nodeUI.attr "transform", "translate(" + (pos.x) + "," + (pos.y - nodeSize / 2) + ")"


  layout = Viva.Graph.Layout.forceDirected graph,
    springLength : 1000,
    springCoeff : 10.0005,
    dragCoeff : 0.02,
    gravity : -0.8

  renderer = Viva.Graph.View.renderer graph,
    graphics: graphics
    container: document.getElementById('graphDiv')
  renderer.run()