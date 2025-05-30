<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="description" content="Hoang Nam Hotel" />
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Hoang Nam Hotel - Forget Password</title>
    <link rel="shortcut icon" href="assets/images/favicon.png" />
    <link rel="stylesheet" href="assets/css/assets.css">
    <link rel="stylesheet" href="assets/css/typography.css">
    <link rel="stylesheet" href="assets/css/shortcodes/shortcodes.css">
    <link rel="stylesheet" href="assets/css/style.css">
    <link class="skin" rel="stylesheet" href="assets/css/color/color-1.css">
</head>
<body id="bg">
    <div class="page-wraper">
        <div id="loading-icon-bx"></div>
        <div class="account-form">
            <div class="account-head" style="background-image:url(assets/images/background/bg2.jpg);">
<!--                <a href="index.jsp"><img src="assets/images/logo-white-2.png" alt="Logo"></a>-->
            </div>
            <div class="account-form-inner">
                <div class="account-container">
                    <div class="heading-bx left">
                        <h2 class="title-head">Forget <span>Password</span></h2>
                        <p>Login Your Account <a href="login.jsp">Click here</a></p>
                    </div>
                    <form method="post" action="${pageContext.request.contextPath}/requestPassword" class="contact-bx">
                        <div class="row placeani">
                            <div class="col-lg-12">
                                <div class="form-group">
                                    <div class="input-group">
                                        <label>Your Email Address</label>
                                        <input name="email" type="email" required class="form-control">
                                    <//div>
                                </div>
                            </div>
                            <div class="col-lg-12 m-b30">
                                <button type="submit" class="btn button-md">Submit</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <script src="assets/js/jquery.min.js"></script>
    <script src="assets/vendors/bootstrap/js/popper.min.js"></script>
    <script src="assets/vendors/bootstrap/js/bootstrap.min.js"></script>
    <script src="assets/vendors/bootstrap-select/bootstrap-select.min.js"></script>
    <script src="assets/vendors/bootstrap-touchspin/jquery.bootstrap-touchspin.js"></script>
    <script src="assets/vendors/magnific-popup/magnific-popup.js"></script>
    <script src="assets/vendors/owl-carousel/owl.carousel.js"></script>
    <script src="assets/js/functions.js"></script>
    <script src="assets/js/contact.js"></script>
</body>
</html>
