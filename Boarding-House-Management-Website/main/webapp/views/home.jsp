<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>AKDD House - Boarding House Management</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=DM+Serif+Display&display=swap" rel="stylesheet">
    <style>
        /* ===== BASE ===== */
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --primary:    #4f46e5;
            --primary-d:  #3730a3;
            --primary-l:  #818cf8;
            --accent:     #f59e0b;
            --accent-d:   #d97706;
            --surface:    #f8fafc;
            --surface-2:  #f1f5f9;
            --text:       #0f172a;
            --text-m:     #475569;
            --text-l:     #94a3b8;
            --white:      #ffffff;
            --radius:     16px;
            --shadow-sm:  0 1px 3px rgba(0,0,0,.08), 0 1px 2px rgba(0,0,0,.06);
            --shadow:     0 4px 20px rgba(0,0,0,.10);
            --shadow-lg:  0 20px 50px rgba(0,0,0,.14);
        }

        html { scroll-behavior: smooth; }

        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background: var(--surface);
            color: var(--text);
            overflow-x: hidden;
        }

        /* ===== NAVBAR ===== */
        .home-nav {
            position: fixed;
            top: 0; left: 0; right: 0;
            z-index: 1000;
            padding: 1rem 0;
            transition: all .3s ease;
            background: transparent;
        }
        .home-nav.scrolled {
            background: rgba(255,255,255,.95);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            padding: .65rem 0;
            box-shadow: var(--shadow-sm);
        }
        .home-nav .nav-brand {
            display: flex; align-items: center; gap: .6rem;
            font-weight: 800; font-size: 1.2rem;
            color: var(--white);
            text-decoration: none;
            transition: color .3s;
        }
        .home-nav.scrolled .nav-brand { color: var(--text); }
        .nav-brand .brand-dot {
            width: 36px; height: 36px;
            background: linear-gradient(135deg, var(--primary), var(--primary-l));
            border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            color: #fff; font-size: 1rem;
        }
        .home-nav .nav-link-item {
            color: rgba(255,255,255,.85);
            text-decoration: none;
            font-size: .9rem; font-weight: 500;
            padding: .45rem .85rem;
            border-radius: 8px;
            transition: all .2s;
        }
        .home-nav .nav-link-item:hover {
            color: #fff;
            background: rgba(255,255,255,.12);
        }
        .home-nav.scrolled .nav-link-item { color: var(--text-m); }
        .home-nav.scrolled .nav-link-item:hover {
            color: var(--primary);
            background: rgba(79,70,229,.07);
        }
        .nav-cta-outline {
            border: 1.5px solid rgba(255,255,255,.6);
            color: #fff !important;
            padding: .45rem 1.1rem !important;
            border-radius: 8px;
            font-weight: 600 !important;
            transition: all .2s !important;
            text-decoration: none; font-size: .9rem;
        }
        .nav-cta-outline:hover {
            background: rgba(255,255,255,.15) !important;
            border-color: #fff !important;
        }
        .home-nav.scrolled .nav-cta-outline {
            border-color: var(--primary);
            color: var(--primary) !important;
        }
        .home-nav.scrolled .nav-cta-outline:hover {
            background: var(--primary) !important;
            color: #fff !important;
        }
        .nav-cta-fill {
            background: var(--accent);
            color: #fff !important;
            padding: .45rem 1.3rem !important;
            border-radius: 8px;
            font-weight: 700 !important;
            text-decoration: none; font-size: .9rem;
            transition: background .2s !important;
        }
        .nav-cta-fill:hover { background: var(--accent-d) !important; }

        /* ===== HERO ===== */
        .hero {
            min-height: 100vh;
            background: url('https://img.homedy.com/store/images/2020/04/15/phong-ngu-khach-san-5-sao-637225597309796831.jpg') center/cover no-repeat;
            display: flex; align-items: center;
            position: relative;
            overflow: hidden;
        }hhjmnb
        .hero::before {
            content: '';
            position: absolute; inset: 0;
            /* dark overlay so text stays legible over photo */
            background: rgba(10, 8, 30, 0.62);
        }
        /* floating blobs */
        .hero-blob {
            position: absolute;
            border-radius: 50%;
            filter: blur(70px);
            opacity: .35;
            animation: floatBlob 8s ease-in-out infinite;
        }
        .hero-blob-1 { width: 500px; height: 500px; background: #818cf8; top: -100px; right: -80px; animation-delay: 0s; }
        .hero-blob-2 { width: 350px; height: 350px; background: #a78bfa; bottom: -80px; left: 10%; animation-delay: -3s; }
        .hero-blob-3 { width: 200px; height: 200px; background: #f59e0b; top: 30%; left: 55%; animation-delay: -5s; opacity: .2; }

        @keyframes floatBlob {
            0%, 100% { transform: translateY(0) scale(1); }
            50%       { transform: translateY(-30px) scale(1.05); }
        }

        /* grid lines decoration */
        .hero-grid {
            position: absolute; inset: 0;
            background-image:
                linear-gradient(rgba(255,255,255,.03) 1px, transparent 1px),
                linear-gradient(90deg, rgba(255,255,255,.03) 1px, transparent 1px);
            background-size: 60px 60px;
        }

        .hero-content { position: relative; z-index: 2; }

        .hero-badge {
            display: inline-flex; align-items: center; gap: .5rem;
            background: rgba(255,255,255,.1);
            border: 1px solid rgba(255,255,255,.2);
            backdrop-filter: blur(8px);
            color: #c7d2fe;
            font-size: .8rem; font-weight: 600;
            padding: .4rem 1rem;
            border-radius: 999px;
            letter-spacing: .04em;
            margin-bottom: 1.5rem;
        }
        .hero-badge-dot {
            width: 7px; height: 7px;
            background: #34d399;
            border-radius: 50%;
            animation: pulse 2s ease-in-out infinite;
        }
        @keyframes pulse {
            0%, 100% { opacity: 1; transform: scale(1); }
            50% { opacity: .5; transform: scale(1.3); }
        }

        .hero h1 {
            font-family: 'DM Serif Display', serif;
            font-size: clamp(2.8rem, 6vw, 5rem);
            line-height: 1.12;
            color: #fff;
            margin-bottom: 1.5rem;
        }
        .hero h1 span {
            background: linear-gradient(90deg, #fbbf24, #f59e0b);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .hero p {
            font-size: 1.15rem;
            color: rgba(255,255,255,.75);
            max-width: 540px;
            line-height: 1.7;
            margin-bottom: 2.5rem;
        }

        .hero-actions { display: flex; gap: 1rem; flex-wrap: wrap; }
        .btn-hero-primary {
            background: var(--accent);
            color: #fff;
            border: none;
            padding: .85rem 2rem;
            border-radius: 12px;
            font-weight: 700; font-size: 1rem;
            cursor: pointer;
            transition: all .25s;
            text-decoration: none;
            display: inline-flex; align-items: center; gap: .5rem;
            box-shadow: 0 4px 20px rgba(245,158,11,.4);
        }
        .btn-hero-primary:hover {
            background: var(--accent-d);
            transform: translateY(-2px);
            box-shadow: 0 8px 28px rgba(245,158,11,.5);
            color: #fff;
        }
        .btn-hero-outline {
            background: rgba(255,255,255,.1);
            color: #fff;
            border: 1.5px solid rgba(255,255,255,.35);
            padding: .85rem 2rem;
            border-radius: 12px;
            font-weight: 600; font-size: 1rem;
            cursor: pointer;
            transition: all .25s;
            text-decoration: none;
            display: inline-flex; align-items: center; gap: .5rem;
            backdrop-filter: blur(8px);
        }
        .btn-hero-outline:hover {
            background: rgba(255,255,255,.18);
            border-color: rgba(255,255,255,.6);
            transform: translateY(-2px);
            color: #fff;
        }

        /* hero stats */
        .hero-stats {
            display: flex; gap: 2.5rem; flex-wrap: wrap;
            margin-top: 3.5rem;
            padding-top: 2.5rem;
            border-top: 1px solid rgba(255,255,255,.12);
        }
        .hero-stat { color: #fff; }
        .hero-stat strong { display: block; font-size: 1.9rem; font-weight: 800; line-height: 1; }
        .hero-stat span { font-size: .85rem; color: rgba(255,255,255,.6); margin-top: .25rem; display: block; }

        /* hero visual card */
        .hero-visual {
            position: relative; z-index: 2;
        }
        .hero-card-main {
            background: rgba(255,255,255,.1);
            border: 1px solid rgba(255,255,255,.2);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            padding: 2rem;
            max-width: 380px;
            margin: 0 auto;
        }
        .room-preview-img {
            width: 100%; height: 200px;
            background-size: cover;
            background-position: center;
            border-radius: 16px;
            margin-bottom: 1.25rem;
            position: relative; overflow: hidden;
        }
        .room-preview-img::after {
            content: '';
            position: absolute; inset: 0;
            background: linear-gradient(to bottom, transparent 50%, rgba(0,0,0,.3));
        }
        .room-preview-badge {
            position: absolute; bottom: .75rem; left: .75rem;
            background: #10b981;
            color: #fff; font-size: .72rem; font-weight: 700;
            padding: .3rem .7rem; border-radius: 6px;
            z-index: 1; letter-spacing: .04em;
        }
        .room-preview-info h4 { color: #fff; font-size: 1.05rem; font-weight: 700; margin-bottom: .4rem; }
        .room-preview-info p { color: rgba(255,255,255,.65); font-size: .85rem; margin: 0; }
        .room-price { color: var(--accent); font-size: 1.3rem; font-weight: 800; }
        .room-price span { color: rgba(255,255,255,.5); font-size: .8rem; font-weight: 400; }

        /* floating mini cards */
        .float-card {
            position: absolute;
            background: rgba(255,255,255,.95);
            border-radius: 14px;
            padding: .75rem 1rem;
            display: flex; align-items: center; gap: .6rem;
            box-shadow: 0 8px 32px rgba(0,0,0,.2);
            animation: floatCard 4s ease-in-out infinite;
        }
        .float-card-1 { top: -20px; right: -30px; animation-delay: 0s; }
        .float-card-2 { bottom: 60px; left: -40px; animation-delay: -2s; }
        @keyframes floatCard {
            0%,100% { transform: translateY(0); }
            50%      { transform: translateY(-8px); }
        }
        .float-card-icon {
            width: 36px; height: 36px; border-radius: 9px;
            display: flex; align-items: center; justify-content: center; font-size: .95rem;
        }
        .float-card-text { line-height: 1.2; }
        .float-card-text strong { font-size: .82rem; color: var(--text); font-weight: 700; display: block; }
        .float-card-text span { font-size: .73rem; color: var(--text-l); }

        /* ===== SECTION COMMONS ===== */
        section { padding: 6rem 0; }
        .section-badge {
            display: inline-flex; align-items: center; gap: .4rem;
            background: rgba(79,70,229,.08);
            color: var(--primary);
            font-size: .78rem; font-weight: 700;
            padding: .35rem .85rem; border-radius: 999px;
            letter-spacing: .06em; text-transform: uppercase;
            margin-bottom: 1rem;
        }
        .section-title {
            font-family: 'DM Serif Display', serif;
            font-size: clamp(2rem, 4vw, 2.8rem);
            line-height: 1.2;
            color: var(--text);
            margin-bottom: 1rem;
        }
        .section-desc {
            font-size: 1.05rem;
            color: var(--text-m);
            line-height: 1.7;
            max-width: 600px;
        }

        /* ===== FEATURES ===== */
        .features-section { background: var(--white); }
        .feature-card {
            padding: 2rem;
            border-radius: var(--radius);
            border: 1.5px solid #e2e8f0;
            height: 100%;
            transition: all .3s;
            background: var(--white);
        }
        .feature-card:hover {
            border-color: var(--primary-l);
            box-shadow: 0 12px 40px rgba(79,70,229,.12);
            transform: translateY(-4px);
        }
        .feature-icon {
            width: 52px; height: 52px;
            border-radius: 14px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.4rem;
            margin-bottom: 1.25rem;
        }
        .feature-card h5 { font-size: 1rem; font-weight: 700; margin-bottom: .5rem; color: var(--text); }
        .feature-card p { font-size: .9rem; color: var(--text-m); line-height: 1.6; margin: 0; }

        /* ===== ROOMS ===== */
        .rooms-section { background: var(--surface); }
        .room-card {
            background: var(--white);
            border-radius: 20px;
            overflow: hidden;
            box-shadow: var(--shadow-sm);
            border: 1px solid #e2e8f0;
            transition: all .3s;
            height: 100%;
        }
        .room-card:hover {
            box-shadow: var(--shadow-lg);
            transform: translateY(-6px);
        }
        .room-card-img {
            height: 210px;
            background-size: cover;
            background-position: center;
            position: relative;
        }
        /* fallback colour kept per variant in case image fails to load */
        .room-card-img.variant-2 { background-color: #0ea5e9; }
        .room-card-img.variant-3 { background-color: #10b981; }
        .room-card-img.variant-4 { background-color: #f59e0b; }
        .room-status-badge {
            position: absolute; top: .85rem; right: .85rem;
            font-size: .7rem; font-weight: 700;
            padding: .3rem .7rem; border-radius: 6px;
            letter-spacing: .04em;
        }
        .badge-available { background: #dcfce7; color: #16a34a; }
        .badge-occupied  { background: #fee2e2; color: #dc2626; }
        .room-card-body { padding: 1.4rem; }
        .room-category-tag {
            display: inline-block;
            background: rgba(79,70,229,.08);
            color: var(--primary);
            font-size: .72rem; font-weight: 700;
            padding: .25rem .65rem; border-radius: 6px;
            letter-spacing: .04em; text-transform: uppercase;
            margin-bottom: .75rem;
        }
        .room-card-body h5 { font-size: 1.05rem; font-weight: 700; margin-bottom: .3rem; color: var(--text); }
        .room-card-body .room-meta {
            font-size: .85rem; color: var(--text-m); margin-bottom: 1rem;
            display: flex; align-items: center; gap: .35rem;
        }
        .room-card-footer {
            display: flex; align-items: center; justify-content: space-between;
            border-top: 1px solid #f1f5f9;
            padding: 1rem 1.4rem;
        }
        .room-price-tag { font-size: 1.2rem; font-weight: 800; color: var(--primary); }
        .room-price-tag small { font-size: .75rem; font-weight: 400; color: var(--text-l); }
        .btn-view-room {
            background: var(--surface-2);
            color: var(--text);
            border: none;
            padding: .45rem 1rem;
            border-radius: 8px;
            font-size: .85rem; font-weight: 600;
            text-decoration: none;
            transition: all .2s;
            display: inline-flex; align-items: center; gap: .35rem;
        }
        .btn-view-room:hover {
            background: var(--primary);
            color: #fff;
        }

        /* ===== HOW IT WORKS ===== */
        .steps-section { background: var(--white); }
        .step-connector {
            display: none;
        }
        @media (min-width: 768px) {
            .step-connector {
                display: block;
                position: absolute;
                top: 28px; left: calc(50% + 28px);
                width: calc(100% - 56px);
                height: 2px;
                background: repeating-linear-gradient(90deg, var(--primary-l) 0, var(--primary-l) 8px, transparent 8px, transparent 16px);
            }
        }
        .step-item { position: relative; text-align: center; }
        .step-num {
            width: 56px; height: 56px;
            background: linear-gradient(135deg, var(--primary), var(--primary-l));
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            color: #fff; font-size: 1.2rem; font-weight: 800;
            margin: 0 auto 1.25rem;
            position: relative; z-index: 1;
            box-shadow: 0 4px 16px rgba(79,70,229,.35);
        }
        .step-item h6 { font-size: .98rem; font-weight: 700; margin-bottom: .4rem; color: var(--text); }
        .step-item p  { font-size: .87rem; color: var(--text-m); line-height: 1.6; max-width: 200px; margin: 0 auto; }

        /* ===== SERVICES ===== */
        .services-section { background: var(--surface); }
        .service-chip {
            display: inline-flex; align-items: center; gap: .6rem;
            background: var(--white);
            border: 1.5px solid #e2e8f0;
            border-radius: 12px;
            padding: .85rem 1.2rem;
            font-size: .9rem; font-weight: 600;
            color: var(--text);
            transition: all .25s;
            cursor: default;
            text-decoration: none;
        }
        .service-chip:hover {
            border-color: var(--primary-l);
            color: var(--primary);
            background: rgba(79,70,229,.04);
            transform: translateY(-2px);
            box-shadow: var(--shadow);
        }
        .service-chip-icon {
            width: 36px; height: 36px;
            border-radius: 9px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1rem;
        }

        /* ===== CTA ===== */
        .cta-section {
            background: linear-gradient(135deg, #1e1b4b 0%, #4f46e5 60%, #7c3aed 100%);
            position: relative; overflow: hidden;
        }
        .cta-section::before {
            content: '';
            position: absolute; inset: 0;
            background-image:
                radial-gradient(ellipse 50% 80% at 80% 50%, rgba(167,139,250,.3), transparent 70%),
                linear-gradient(rgba(255,255,255,.02) 1px, transparent 1px),
                linear-gradient(90deg, rgba(255,255,255,.02) 1px, transparent 1px);
            background-size: auto, 60px 60px, 60px 60px;
        }
        .cta-section .container { position: relative; z-index: 1; }
        .cta-section h2 {
            font-family: 'DM Serif Display', serif;
            font-size: clamp(2rem, 4vw, 3rem);
            color: #fff; margin-bottom: 1rem;
        }
        .cta-section p { color: rgba(255,255,255,.75); font-size: 1.05rem; line-height: 1.7; }

        /* ===== CONTACT ===== */
        .contact-section { background: var(--white); }
        .contact-form-card {
            background: var(--white);
            border: 1.5px solid #e2e8f0;
            border-radius: 20px;
            padding: 2.5rem;
            box-shadow: var(--shadow-sm);
        }
        .contact-info-card {
            background: linear-gradient(145deg, #4f46e5, #7c3aed);
            border-radius: 20px;
            padding: 2.5rem;
            color: #fff;
            height: 100%;
        }
        .contact-info-card h4 { font-size: 1.4rem; font-weight: 700; margin-bottom: .5rem; }
        .contact-info-card p { color: rgba(255,255,255,.75); line-height: 1.6; }
        .contact-info-item {
            display: flex; align-items: flex-start; gap: 1rem;
            margin-bottom: 1.5rem;
        }
        .contact-info-icon {
            width: 40px; height: 40px; flex-shrink: 0;
            background: rgba(255,255,255,.15);
            border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1rem;
        }
        .contact-info-text strong { display: block; font-size: .88rem; font-weight: 700; margin-bottom: .2rem; }
        .contact-info-text span { font-size: .85rem; color: rgba(255,255,255,.7); }
        .form-control-custom {
            border: 1.5px solid #e2e8f0;
            border-radius: 10px;
            padding: .7rem 1rem;
            font-size: .9rem;
            transition: border-color .2s, box-shadow .2s;
            font-family: inherit;
            width: 100%;
            background: var(--white);
            color: var(--text);
        }
        .form-control-custom:focus {
            border-color: var(--primary-l);
            box-shadow: 0 0 0 3px rgba(79,70,229,.1);
            outline: none;
        }
        .form-label-custom { font-size: .85rem; font-weight: 600; color: var(--text-m); margin-bottom: .4rem; display: block; }

        /* ===== FOOTER ===== */
        .site-footer {
            background: #0f172a;
            color: rgba(255,255,255,.65);
            padding: 4rem 0 2rem;
        }
        .footer-brand { font-weight: 800; font-size: 1.2rem; color: #fff; margin-bottom: .5rem; display: flex; align-items: center; gap: .6rem; }
        .footer-brand .brand-dot { background: linear-gradient(135deg, var(--primary), var(--primary-l)); }
        .footer-desc { font-size: .88rem; line-height: 1.7; max-width: 280px; }
        .footer-heading { font-size: .75rem; font-weight: 700; color: rgba(255,255,255,.4); text-transform: uppercase; letter-spacing: .1em; margin-bottom: 1rem; }
        .footer-links { list-style: none; padding: 0; margin: 0; }
        .footer-links li { margin-bottom: .5rem; }
        .footer-links a {
            color: rgba(255,255,255,.6);
            text-decoration: none;
            font-size: .88rem;
            transition: color .2s;
        }
        .footer-links a:hover { color: #fff; }
        .footer-divider { border-color: rgba(255,255,255,.08); margin: 2rem 0 1.5rem; }
        .footer-bottom {
            display: flex; align-items: center; justify-content: space-between;
            flex-wrap: wrap; gap: 1rem;
            font-size: .82rem;
        }
        .social-links { display: flex; gap: .6rem; }
        .social-link {
            width: 34px; height: 34px;
            background: rgba(255,255,255,.08);
            border-radius: 8px;
            display: flex; align-items: center; justify-content: center;
            color: rgba(255,255,255,.6);
            text-decoration: none;
            transition: all .2s;
        }
        .social-link:hover { background: var(--primary); color: #fff; }

        /* ===== SCROLL REVEAL ===== */
        .reveal {
            opacity: 0;
            transform: translateY(28px);
            transition: opacity .6s ease, transform .6s ease;
        }
        .reveal.visible {
            opacity: 1;
            transform: none;
        }
        .reveal-delay-1 { transition-delay: .1s; }
        .reveal-delay-2 { transition-delay: .2s; }
        .reveal-delay-3 { transition-delay: .3s; }

        /* ===== MOBILE ===== */
        @media (max-width: 991px) {
            .hero { min-height: auto; padding: 8rem 0 5rem; }
            .hero-visual { margin-top: 3rem; }
            .hero-card-main { max-width: 100%; }
            .float-card-1, .float-card-2 { display: none; }
            .hero-stats { gap: 1.5rem; }
        }
        @media (max-width: 576px) {
            .hero h1 { font-size: 2.4rem; }
            .hero-actions { flex-direction: column; }
            .btn-hero-primary, .btn-hero-outline { justify-content: center; }
        }
    </style>
</head>
<body>

<!-- ===== NAVBAR ===== -->
<nav class="home-nav" id="homeNav">
    <div class="container">
        <div class="d-flex align-items-center justify-content-between">
            <a href="${pageContext.request.contextPath}/" class="nav-brand">
                <span class="brand-dot"><i class="bi bi-house-fill"></i></span>
                AKDD House
            </a>
            <!-- desktop links -->
            <div class="d-none d-lg-flex align-items-center gap-1">
                <a href="#features"  class="nav-link-item">Features</a>
                <a href="#rooms"     class="nav-link-item">Rooms</a>
                <a href="#services"  class="nav-link-item">Services</a>
                <a href="#how"       class="nav-link-item">How It Works</a>
            </div>
            <div class="d-none d-lg-flex align-items-center gap-2">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <a href="${pageContext.request.contextPath}/dashboard" class="nav-cta-fill">
                            <i class="bi bi-grid-fill"></i> Dashboard
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/auth?action=login" class="nav-cta-outline">Sign In</a>
                        <a href="${pageContext.request.contextPath}/auth?action=register" class="nav-cta-fill">Get Started</a>
                    </c:otherwise>
                </c:choose>
            </div>
            <!-- mobile toggle -->
            <button class="d-lg-none btn btn-sm" id="mobileMenuToggle"
                    style="color:#fff; background:rgba(255,255,255,.1); border:1px solid rgba(255,255,255,.2); border-radius:8px; padding:.4rem .6rem;">
                <i class="bi bi-list fs-5"></i>
            </button>
        </div>
        <!-- mobile menu -->
        <div id="mobileMenu" style="display:none; padding-top:1rem;">
            <div class="d-flex flex-column gap-1">
                <a href="#features" class="nav-link-item" style="color:rgba(255,255,255,.85);">Features</a>
                <a href="#rooms"    class="nav-link-item" style="color:rgba(255,255,255,.85);">Rooms</a>
                <a href="#services" class="nav-link-item" style="color:rgba(255,255,255,.85);">Services</a>
                <hr style="border-color:rgba(255,255,255,.15); margin:.5rem 0;">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <a href="${pageContext.request.contextPath}/dashboard" class="nav-cta-fill text-center">Dashboard</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/auth?action=login"    class="nav-cta-outline text-center mb-1">Sign In</a>
                        <a href="${pageContext.request.contextPath}/auth?action=register" class="nav-cta-fill text-center">Get Started</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>

<!-- ===== HERO ===== -->
<section class="hero">
    <div class="hero-grid"></div>
    <div class="hero-blob hero-blob-1"></div>
    <div class="hero-blob hero-blob-2"></div>
    <div class="hero-blob hero-blob-3"></div>

    <div class="container">
        <div class="row align-items-center gy-5">

            <!-- Left: copy -->
            <div class="col-lg-6 hero-content">
                <div class="hero-badge">
                    <span class="hero-badge-dot"></span>
                    Now accepting new tenants
                </div>
                <h1>
                    Find Your Perfect<br>
                    <span>Boarding Room</span><br>
                    With Ease
                </h1>
                <p>
                    AKDD House is a modern boarding house management platform — browse rooms, manage contracts, track bills and utilities all in one place.
                </p>
                <div class="hero-actions">
                    <a href="${pageContext.request.contextPath}/room?action=publicList&status=available" class="btn-hero-primary">
                        <i class="bi bi-search"></i> Browse Rooms
                    </a>
                    <a href="${pageContext.request.contextPath}/auth?action=register" class="btn-hero-outline">
                        <i class="bi bi-person-plus"></i> Create Account
                    </a>
                </div>
                <div class="hero-stats">
                    <div class="hero-stat">
                        <strong>50+</strong>
                        <span>Total Rooms</span>
                    </div>
                    <div class="hero-stat">
                        <strong>4</strong>
                        <span>Room Categories</span>
                    </div>
                    <div class="hero-stat">
                        <strong>24/7</strong>
                        <span>Support Access</span>
                    </div>
                    <div class="hero-stat">
                        <strong>100%</strong>
                        <span>Online Management</span>
                    </div>
                </div>
            </div>

            <!-- Right: visual card -->
            <div class="col-lg-6 hero-visual">
                <div style="position:relative; padding: 2rem 2.5rem;">
                    <div class="hero-card-main">
                        <div class="room-preview-img"
                             style="background-image: url('https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=600&q=80');">
                            <span class="room-preview-badge">Available Now</span>
                        </div>
                        <div class="room-preview-info d-flex justify-content-between align-items-end mt-3">
                            <div>
                                <h4>Standard Room 101</h4>
                                <p><i class="bi bi-geo-alt-fill me-1"></i>AKDD House, Floor 1</p>
                            </div>
                            <div class="text-end">
                                <div class="room-price">2,500,000 <span>VND/mo</span></div>
                            </div>
                        </div>
                        <div class="d-flex gap-2 mt-3">
                            <span style="background:rgba(255,255,255,.12); color:rgba(255,255,255,.7); font-size:.78rem; padding:.3rem .7rem; border-radius:6px; display:flex; align-items:center; gap:.3rem;">
                                <i class="bi bi-wifi"></i> WiFi
                            </span>
                            <span style="background:rgba(255,255,255,.12); color:rgba(255,255,255,.7); font-size:.78rem; padding:.3rem .7rem; border-radius:6px; display:flex; align-items:center; gap:.3rem;">
                                <i class="bi bi-droplet"></i> Water
                            </span>
                            <span style="background:rgba(255,255,255,.12); color:rgba(255,255,255,.7); font-size:.78rem; padding:.3rem .7rem; border-radius:6px; display:flex; align-items:center; gap:.3rem;">
                                <i class="bi bi-lightning-charge"></i> Electric
                            </span>
                        </div>
                    </div>

                    <!-- floating mini cards -->
                    <div class="float-card float-card-1">
                        <div class="float-card-icon" style="background:#dcfce7;">
                            <i class="bi bi-check-circle-fill text-success"></i>
                        </div>
                        <div class="float-card-text">
                            <strong>Room Booked!</strong>
                            <span>Contract signed online</span>
                        </div>
                    </div>
                    <div class="float-card float-card-2">
                        <div class="float-card-icon" style="background:#fef9c3;">
                            <i class="bi bi-receipt text-warning"></i>
                        </div>
                        <div class="float-card-text">
                            <strong>Bill Paid</strong>
                            <span>Monthly utility cleared</span>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</section>

<!-- ===== FEATURES ===== -->
<section class="features-section" id="features">
    <div class="container">
        <div class="row justify-content-center text-center mb-5">
            <div class="col-lg-7 reveal">
                <div class="section-badge"><i class="bi bi-stars"></i> Why AKDD House</div>
                <h2 class="section-title">Everything You Need<br>In One Platform</h2>
                <p class="section-desc mx-auto">
                    From finding a room to paying bills — manage your entire boarding experience digitally without the paperwork.
                </p>
            </div>
        </div>
        <div class="row g-4">
            <div class="col-md-6 col-lg-4 reveal reveal-delay-1">
                <div class="feature-card">
                    <div class="feature-icon" style="background:#ede9fe;">
                        <i class="bi bi-door-open" style="color:#7c3aed;"></i>
                    </div>
                    <h5>Room Browsing</h5>
                    <p>Browse all available rooms with real-time availability status, category filters, and detailed room information.</p>
                </div>
            </div>
            <div class="col-md-6 col-lg-4 reveal reveal-delay-2">
                <div class="feature-card">
                    <div class="feature-icon" style="background:#dbeafe;">
                        <i class="bi bi-file-earmark-text" style="color:#2563eb;"></i>
                    </div>
                    <h5>Digital Contracts</h5>
                    <p>Sign and manage rental contracts online. Review all contract terms and track your rental history anytime.</p>
                </div>
            </div>
            <div class="col-md-6 col-lg-4 reveal reveal-delay-3">
                <div class="feature-card">
                    <div class="feature-icon" style="background:#dcfce7;">
                        <i class="bi bi-receipt-cutoff" style="color:#16a34a;"></i>
                    </div>
                    <h5>Bill Management</h5>
                    <p>Receive and review monthly bills for electricity, water, and services. Track payment history transparently.</p>
                </div>
            </div>
            <div class="col-md-6 col-lg-4 reveal reveal-delay-1">
                <div class="feature-card">
                    <div class="feature-icon" style="background:#fef9c3;">
                        <i class="bi bi-lightning-charge" style="color:#ca8a04;"></i>
                    </div>
                    <h5>Utility Tracking</h5>
                    <p>Monitor electricity and water meter readings each month. Know exactly what you're paying for.</p>
                </div>
            </div>
            <div class="col-md-6 col-lg-4 reveal reveal-delay-2">
                <div class="feature-card">
                    <div class="feature-icon" style="background:#ffe4e6;">
                        <i class="bi bi-bell" style="color:#e11d48;"></i>
                    </div>
                    <h5>Smart Notifications</h5>
                    <p>Get notified about new bills, contract renewals, and important announcements from management in real time.</p>
                </div>
            </div>
            <div class="col-md-6 col-lg-4 reveal reveal-delay-3">
                <div class="feature-card">
                    <div class="feature-icon" style="background:#e0f2fe;">
                        <i class="bi bi-tools" style="color:#0284c7;"></i>
                    </div>
                    <h5>Facility Requests</h5>
                    <p>Submit maintenance requests and track facility services. Access amenities information for your room.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ===== ROOMS ===== -->
<section class="rooms-section" id="rooms">
    <div class="container">
        <div class="row justify-content-between align-items-end mb-5">
            <div class="col-lg-6 reveal">
                <div class="section-badge"><i class="bi bi-building"></i> Our Rooms</div>
                <h2 class="section-title">Browse Available Rooms</h2>
                <p class="section-desc">
                    Choose from a range of well-maintained rooms across different categories to match your budget and needs.
                </p>
            </div>
            <div class="col-lg-auto reveal">
                <a href="${pageContext.request.contextPath}/room?action=publicList"
                   class="btn btn-outline-primary btn-sm px-3 py-2 rounded-3 fw-semibold">
                    View All Rooms <i class="bi bi-arrow-right ms-1"></i>
                </a>
            </div>
        </div>
        <div class="row g-4">
            <!-- Room card 1 -->
            <div class="col-md-6 col-xl-3 reveal reveal-delay-1">
                <div class="room-card">
                    <div class="room-card-img"
                         style="background-image: url('https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=500&q=80');">
                        <span class="room-status-badge badge-available">Available</span>
                    </div>
                    <div class="room-card-body">
                        <span class="room-category-tag">Economy</span>
                        <h5>Standard Room</h5>
                        <div class="room-meta">
                            <i class="bi bi-aspect-ratio"></i> 20m²
                            <span class="mx-1">·</span>
                            <i class="bi bi-person"></i> 1 Person
                        </div>
                    </div>
                    <div class="room-card-footer">
                        <div class="room-price-tag">1,800,000 <small>VND/mo</small></div>
                        <a href="${pageContext.request.contextPath}/room?action=publicList&status=available"
                           class="btn-view-room">View <i class="bi bi-arrow-right"></i></a>
                    </div>
                </div>
            </div>
            <!-- Room card 2 -->
            <div class="col-md-6 col-xl-3 reveal reveal-delay-2">
                <div class="room-card">
                    <div class="room-card-img variant-2"
                         style="background-image: url('https://images.unsplash.com/photo-1540518614846-7eded433c457?w=500&q=80');">
                        <span class="room-status-badge badge-available">Available</span>
                    </div>
                    <div class="room-card-body">
                        <span class="room-category-tag">Business</span>
                        <h5>Deluxe Room</h5>
                        <div class="room-meta">
                            <i class="bi bi-aspect-ratio"></i> 30m²
                            <span class="mx-1">·</span>
                            <i class="bi bi-people"></i> 2 Persons
                        </div>
                    </div>
                    <div class="room-card-footer">
                        <div class="room-price-tag">2,500,000 <small>VND/mo</small></div>
                        <a href="${pageContext.request.contextPath}/room?action=publicList&status=available"
                           class="btn-view-room">View <i class="bi bi-arrow-right"></i></a>
                    </div>
                </div>
            </div>
            <!-- Room card 3 -->
            <div class="col-md-6 col-xl-3 reveal reveal-delay-3">
                <div class="room-card">
                    <div class="room-card-img variant-3"
                         style="background-image: url('https://images.unsplash.com/photo-1560448204-603b3fc33ddc?w=500&q=80');">
                        <span class="room-status-badge badge-occupied">Occupied</span>
                    </div>
                    <div class="room-card-body">
                        <span class="room-category-tag">Family</span>
                        <h5>Family Suite</h5>
                        <div class="room-meta">
                            <i class="bi bi-aspect-ratio"></i> 45m²
                            <span class="mx-1">·</span>
                            <i class="bi bi-people-fill"></i> 4 Persons
                        </div>
                    </div>
                    <div class="room-card-footer">
                        <div class="room-price-tag">3,800,000 <small>VND/mo</small></div>
                        <a href="${pageContext.request.contextPath}/room?action=publicList"
                           class="btn-view-room">View <i class="bi bi-arrow-right"></i></a>
                    </div>
                </div>
            </div>
            <!-- Room card 4 -->
            <div class="col-md-6 col-xl-3 reveal">
                <div class="room-card">
                    <div class="room-card-img variant-4"
                         style="background-image: url('https://images.unsplash.com/photo-1578898886225-c7c894047899?w=500&q=80');">
                        <span class="room-status-badge badge-available">Available</span>
                    </div>
                    <div class="room-card-body">
                        <span class="room-category-tag">Royal</span>
                        <h5>Premium Suite</h5>
                        <div class="room-meta">
                            <i class="bi bi-aspect-ratio"></i> 60m²
                            <span class="mx-1">·</span>
                            <i class="bi bi-people-fill"></i> 2 Persons
                        </div>
                    </div>
                    <div class="room-card-footer">
                        <div class="room-price-tag">5,500,000 <small>VND/mo</small></div>
                        <a href="${pageContext.request.contextPath}/room?action=publicList&status=available"
                           class="btn-view-room">View <i class="bi bi-arrow-right"></i></a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ===== HOW IT WORKS ===== -->
<section class="steps-section" id="how">
    <div class="container">
        <div class="row justify-content-center text-center mb-5">
            <div class="col-lg-6 reveal">
                <div class="section-badge"><i class="bi bi-map"></i> Simple Process</div>
                <h2 class="section-title">How It Works</h2>
                <p class="section-desc mx-auto">Get settled in your new room in just 4 simple steps — all done digitally.</p>
            </div>
        </div>
        <div class="row g-4 justify-content-center">
            <div class="col-6 col-md-3 step-item reveal reveal-delay-1">
                <div class="step-connector"></div>
                <div class="step-num">1</div>
                <h6>Create Account</h6>
                <p>Register a free account to access all features and start browsing rooms.</p>
            </div>
            <div class="col-6 col-md-3 step-item reveal reveal-delay-2">
                <div class="step-num">2</div>
                <h6>Browse Rooms</h6>
                <p>Filter available rooms by category, price, and size to find your match.</p>
            </div>
            <div class="col-6 col-md-3 step-item reveal reveal-delay-3">
                <div class="step-num">3</div>
                <h6>Sign Contract</h6>
                <p>Complete your rental contract digitally with the management team.</p>
            </div>
            <div class="col-6 col-md-3 step-item reveal">
                <div class="step-num">4</div>
                <h6>Move In &amp; Manage</h6>
                <p>Track bills, services, and utilities straight from your dashboard.</p>
            </div>
        </div>
    </div>
</section>

<!-- ===== SERVICES ===== -->
<section class="services-section" id="services">
    <div class="container">
        <div class="row justify-content-center text-center mb-5">
            <div class="col-lg-6 reveal">
                <div class="section-badge"><i class="bi bi-grid-1x2"></i> Our Services</div>
                <h2 class="section-title">Services &amp; Amenities</h2>
                <p class="section-desc mx-auto">
                    Enjoy a range of services and amenities included with your room or available as add-ons.
                </p>
            </div>
        </div>
        <div class="d-flex flex-wrap gap-3 justify-content-center reveal">
            <a href="${pageContext.request.contextPath}/services" class="service-chip">
                <span class="service-chip-icon" style="background:#ede9fe;"><i class="bi bi-wifi" style="color:#7c3aed;"></i></span>
                High-Speed WiFi
            </a>
            <a href="${pageContext.request.contextPath}/services" class="service-chip">
                <span class="service-chip-icon" style="background:#dcfce7;"><i class="bi bi-droplet-fill" style="color:#16a34a;"></i></span>
                Water Supply
            </a>
            <a href="${pageContext.request.contextPath}/services" class="service-chip">
                <span class="service-chip-icon" style="background:#fef9c3;"><i class="bi bi-lightning-charge-fill" style="color:#ca8a04;"></i></span>
                Electricity
            </a>
            <a href="${pageContext.request.contextPath}/services" class="service-chip">
                <span class="service-chip-icon" style="background:#dbeafe;"><i class="bi bi-trash3-fill" style="color:#2563eb;"></i></span>
                Garbage Collection
            </a>
            <a href="${pageContext.request.contextPath}/services" class="service-chip">
                <span class="service-chip-icon" style="background:#ffe4e6;"><i class="bi bi-shield-fill-check" style="color:#e11d48;"></i></span>
                24/7 Security
            </a>
            <a href="${pageContext.request.contextPath}/services" class="service-chip">
                <span class="service-chip-icon" style="background:#e0f2fe;"><i class="bi bi-camera-video-fill" style="color:#0284c7;"></i></span>
                CCTV Monitoring
            </a>
            <a href="${pageContext.request.contextPath}/services" class="service-chip">
                <span class="service-chip-icon" style="background:#fef3c7;"><i class="bi bi-car-front-fill" style="color:#d97706;"></i></span>
                Parking
            </a>
            <a href="${pageContext.request.contextPath}/services" class="service-chip">
                <span class="service-chip-icon" style="background:#f3e8ff;"><i class="bi bi-tv-fill" style="color:#9333ea;"></i></span>
                Cable TV
            </a>
        </div>
        <div class="text-center mt-4 reveal">
            <a href="${pageContext.request.contextPath}/services"
               class="btn btn-outline-primary px-4 py-2 rounded-3 fw-semibold">
                View All Services <i class="bi bi-arrow-right ms-1"></i>
            </a>
        </div>
    </div>
</section>

<!-- ===== CTA ===== -->
<section class="cta-section py-6" style="padding:6rem 0;">
    <div class="container">
        <div class="row align-items-center gy-4">
            <div class="col-lg-7 reveal">
                <h2>Ready to Find Your<br>New Home?</h2>
                <p>Create a free account today and get instant access to all available rooms, services, and management features.</p>
            </div>
            <div class="col-lg-5 text-lg-end reveal">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <a href="${pageContext.request.contextPath}/dashboard"
                           class="btn-hero-primary d-inline-flex">
                            <i class="bi bi-grid-fill"></i> Go to Dashboard
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/auth?action=register"
                           class="btn-hero-primary d-inline-flex me-2">
                            <i class="bi bi-person-plus"></i> Sign Up Free
                        </a>
                        <a href="${pageContext.request.contextPath}/room?action=publicList"
                           class="btn-hero-outline d-inline-flex mt-2 mt-sm-0">
                            <i class="bi bi-search"></i> Browse Rooms
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</section>

<!-- ===== FOOTER ===== -->
<footer class="site-footer">
    <div class="container">
        <div class="row g-4">
            <div class="col-lg-4">
                <div class="footer-brand">
                    <span class="brand-dot" style="width:32px; height:32px; border-radius:9px; display:flex; align-items:center; justify-content:center; color:#fff; font-size:.9rem;">
                        <i class="bi bi-house-fill"></i>
                    </span>
                    AKDD House
                </div>
                <p class="footer-desc">
                    A modern boarding house management system. Find rooms, manage contracts, and track bills all in one place.
                </p>
            </div>
            <div class="col-6 col-lg-2">
                <div class="footer-heading">Navigation</div>
                <ul class="footer-links">
                    <li><a href="#features">Features</a></li>
                    <li><a href="#rooms">Rooms</a></li>
                    <li><a href="#services">Services</a></li>
                    <li><a href="#how">How It Works</a></li>
                </ul>
            </div>
            <div class="col-6 col-lg-2">
                <div class="footer-heading">Account</div>
                <ul class="footer-links">
                    <li><a href="${pageContext.request.contextPath}/auth?action=login">Sign In</a></li>
                    <li><a href="${pageContext.request.contextPath}/auth?action=register">Register</a></li>
                    <li><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                    <li><a href="${pageContext.request.contextPath}/customer?action=myRoom">My Room</a></li>
                    <li><a href="${pageContext.request.contextPath}/contract">Contracts</a></li>
                </ul>
            </div>
            <div class="col-6 col-lg-2">
                <div class="footer-heading">Rooms</div>
                <ul class="footer-links">
                    <li><a href="${pageContext.request.contextPath}/room?action=categories">Categories</a></li>
                    <li><a href="${pageContext.request.contextPath}/room?action=publicList">All Rooms</a></li>
                    <li><a href="${pageContext.request.contextPath}/room?action=publicList&status=available">Available</a></li>
                    <li><a href="${pageContext.request.contextPath}/services">Services</a></li>
                </ul>
            </div>
            <div class="col-6 col-lg-2">
                <div class="footer-heading">Support</div>
                <ul class="footer-links">
                    <li><a href="${pageContext.request.contextPath}/notification">Notifications</a></li>
                    <li><a href="${pageContext.request.contextPath}/bill">My Bills</a></li>
                </ul>
            </div>
        </div>
        <hr class="footer-divider">
        <div class="footer-bottom">
            <span>&copy; 2025 AKDD House. All rights reserved.</span>
            <div class="social-links">
                <a href="#" class="social-link" title="Facebook"><i class="bi bi-facebook"></i></a>
                <a href="#" class="social-link" title="Twitter"><i class="bi bi-twitter-x"></i></a>
                <a href="#" class="social-link" title="Instagram"><i class="bi bi-instagram"></i></a>
                <a href="#" class="social-link" title="Zalo"><i class="bi bi-chat-fill"></i></a>
            </div>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Navbar scroll behavior
    const nav = document.getElementById('homeNav');
    window.addEventListener('scroll', () => {
        nav.classList.toggle('scrolled', window.scrollY > 40);
    });

    // Mobile menu toggle
    document.getElementById('mobileMenuToggle').addEventListener('click', function() {
        const menu = document.getElementById('mobileMenu');
        menu.style.display = menu.style.display === 'none' ? 'block' : 'none';
    });

    // Mobile nav links close menu
    document.querySelectorAll('#mobileMenu a').forEach(link => {
        link.addEventListener('click', () => {
            document.getElementById('mobileMenu').style.display = 'none';
        });
    });

    // Scroll reveal
    const revealEls = document.querySelectorAll('.reveal');
    const revealObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('visible');
                revealObserver.unobserve(entry.target);
            }
        });
    }, { threshold: 0.12 });
    revealEls.forEach(el => revealObserver.observe(el));

    // Smooth anchor scrolling
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                e.preventDefault();
                target.scrollIntoView({ behavior: 'smooth', block: 'start' });
            }
        });
    });
</script>

</body>
</html>
