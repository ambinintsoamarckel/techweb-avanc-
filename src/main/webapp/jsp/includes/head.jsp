<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><%= request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle") : "Mon Site" %></title>

    <!-- Bootstrap CSS local -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">

    <!-- Bootstrap JS local -->
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js" defer></script>
</head>
