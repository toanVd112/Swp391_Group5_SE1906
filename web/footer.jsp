<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<footer class="footer">
    <!-- Top Section -->
    <div class="footer-top">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center py-3 border-bottom">
                <div class="d-flex align-items-center">
                    <img src="${pageContext.request.contextPath}/assets/images/logo-white.png" alt="Hoang Nam Hotel" class="footer-logo">
                </div>
                <div class="d-flex align-items-center gap-3">
                    <div class="social-links">
                        <a href="#" class="social-link"><i class="fab fa-facebook"></i></a>
                        <a href="#" class="social-link"><i class="fab fa-twitter"></i></a>
                        <a href="#" class="social-link"><i class="fab fa-linkedin"></i></a>
                        <a href="#" class="social-link"><i class="fab fa-google-plus"></i></a>
                    </div>
                    <button class="btn btn-primary">Join Now</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Main Footer Content -->
    <div class="footer-content">
        <div class="container-fluid">
            <div class="row py-5">
                <!-- Newsletter -->
                <div class="col-lg-4 col-md-6 mb-4">
                    <h5 class="footer-title">Sign Up For A Newsletter</h5>
                    <p class="text-muted mb-3">Weekly Breaking news analysis and cutting edge advices on job searching.</p>
                    <div class="input-group">
                        <input type="email" class="form-control" placeholder="Your Email Address">
                        <button class="btn btn-primary" type="button">
                            <i class="fas fa-arrow-right"></i>
                        </button>
                    </div>
                </div>

                <!-- Company Links -->
                <div class="col-lg-2 col-md-3 col-sm-6 mb-4">
                    <h5 class="footer-title">Company</h5>
                    <ul class="footer-links">
                        <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                        <li><a href="${pageContext.request.contextPath}/about.jsp">About</a></li>
                        <li><a href="${pageContext.request.contextPath}/faq.jsp">FAQs</a></li>
                        <li><a href="${pageContext.request.contextPath}/contact.jsp">Contact</a></li>
                    </ul>
                </div>

                <!-- Get In Touch -->
                <div class="col-lg-2 col-md-3 col-sm-6 mb-4">
                    <h5 class="footer-title">Get In Touch</h5>
                    <ul class="footer-links">
                        <li><a href="${pageContext.request.contextPath}/layout.jsp">Dashboard</a></li>
                        <li><a href="${pageContext.request.contextPath}/blog.jsp">Blog</a></li>
                        <li><a href="${pageContext.request.contextPath}/portfolio.jsp">Portfolio</a></li>
                        <li><a href="${pageContext.request.contextPath}/event.jsp">Event</a></li>
                    </ul>
                </div>

                <!-- Rooms -->
                <div class="col-lg-2 col-md-3 col-sm-6 mb-4">
                    <h5 class="footer-title">Rooms</h5>
                    <ul class="footer-links">
                        <li><a href="${pageContext.request.contextPath}/rooms.jsp">Rooms</a></li>
                        <li><a href="${pageContext.request.contextPath}/room-details.jsp">Details</a></li>
                        <li><a href="${pageContext.request.contextPath}/membership.jsp">Membership</a></li>
                        <li><a href="${pageContext.request.contextPath}/profile.jsp">Profile</a></li>
                    </ul>
                </div>

                <!-- Gallery -->
                <div class="col-lg-2 col-md-3 col-sm-6 mb-4">
                    <h5 class="footer-title">Our Gallery</h5>
                    <div class="gallery-grid">
                        <div class="gallery-item">
                            <img src="${pageContext.request.contextPath}/assets/images/gallery/pic1.jpg" alt="Gallery 1">
                        </div>
                        <div class="gallery-item">
                            <img src="${pageContext.request.contextPath}/assets/images/gallery/pic2.jpg" alt="Gallery 2">
                        </div>
                        <div class="gallery-item">
                            <img src="${pageContext.request.contextPath}/assets/images/gallery/pic3.jpg" alt="Gallery 3">
                        </div>
                        <div class="gallery-item">
                            <img src="${pageContext.request.contextPath}/assets/images/gallery/pic4.jpg" alt="Gallery 4">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bottom Footer -->
    <div class="footer-bottom">
        <div class="container-fluid">
            <div class="text-center py-3">
                <p class="mb-0 text-muted">© 2024 Hoang Nam Hotel. All rights reserved.</p>
            </div>
        </div>
    </div>
</footer>