import os

def create_all_assets():
    # 1. ICON (512x512) - High-res Squircle App Icon
    logo_icon_svg = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" width="512" height="512">
  <defs>
    <!-- Background Gradient -->
    <linearGradient id="bg" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#070A12"/>
      <stop offset="50%" stop-color="#0F172A"/>
      <stop offset="100%" stop-color="#191735"/>
    </linearGradient>

    <!-- Top Plate: Idea (Amber -> Rose -> Violet) -->
    <linearGradient id="gradTop" x1="0%" y1="100%" x2="100%" y2="0%">
      <stop offset="0%" stop-color="#F59E0B"/>
      <stop offset="45%" stop-color="#F43F5E"/>
      <stop offset="100%" stop-color="#8B5CF6"/>
    </linearGradient>

    <!-- Left Plate: Blueprint / PRD (Indigo -> Deep Violet) -->
    <linearGradient id="gradLeft" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#6366F1"/>
      <stop offset="100%" stop-color="#312E81"/>
    </linearGradient>

    <!-- Right Plate: Shipped App (Sky -> Cyan -> Emerald) -->
    <linearGradient id="gradRight" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#38BDF8"/>
      <stop offset="50%" stop-color="#06B6D4"/>
      <stop offset="100%" stop-color="#10B981"/>
    </linearGradient>

    <!-- Spark Radial / Light -->
    <linearGradient id="sparkLight" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#FFFFFF"/>
      <stop offset="100%" stop-color="#FEF08A"/>
    </linearGradient>

    <!-- Ambient Center Glow -->
    <radialGradient id="centerGlow" cx="50%" cy="50%" r="50%">
      <stop offset="0%" stop-color="#6366F1" stop-opacity="0.32"/>
      <stop offset="100%" stop-color="#6366F1" stop-opacity="0"/>
    </radialGradient>
  </defs>

  <!-- Squircle Base -->
  <rect width="512" height="512" rx="116" fill="url(#bg)"/>
  <rect x="2" y="2" width="508" height="508" rx="114" fill="none" stroke="#6366F1" stroke-width="2" stroke-opacity="0.25"/>

  <!-- Subtle Radial Glow Behind Prism -->
  <circle cx="256" cy="256" r="170" fill="url(#centerGlow)"/>

  <!-- Centered Floating 3-Plate Prism (Centered at 256, 256) -->
  <g transform="translate(0, 11)">
    <!-- TOP PLATE: IDEA -->
    <g id="topPlate">
      <polygon points="256,90 380,162 256,234 132,162" fill="url(#gradTop)"/>
      <polyline points="132,162 256,90 380,162" fill="none" stroke="#FFFFFF" stroke-width="2.5" stroke-opacity="0.45"/>
      
      <!-- Radiant 4-Point Star Spark -->
      <g transform="translate(256, 162) scale(1, 0.58)">
        <path d="M 0 -68 Q 0 0 -68 0 Q 0 0 0 68 Q 0 0 68 0 Q 0 0 0 -68 Z" fill="url(#sparkLight)"/>
        <circle cx="0" cy="0" r="18" fill="#FFFFFF"/>
      </g>
    </g>

    <!-- LEFT PLATE: PRD / BLUEPRINT -->
    <g id="leftPlate">
      <polygon points="122,180 248,252 248,400 122,328" fill="url(#gradLeft)"/>
      <polyline points="122,180 248,252 248,400" fill="none" stroke="#A5B4FC" stroke-width="2" stroke-opacity="0.35"/>
      
      <!-- Window Header Bar on Blueprint -->
      <polygon points="140,205 230,257 230,273 140,221" fill="#4338CA" fill-opacity="0.6"/>
      <circle cx="154" cy="217" r="4.5" fill="#C7D2FE"/>
      <circle cx="168" cy="225" r="4.5" fill="#C7D2FE"/>

      <!-- Blueprint Architectural Lines -->
      <polygon points="140,240 205,277 205,286 140,249" fill="#818CF8" fill-opacity="0.4"/>
      <polygon points="140,264 220,310 220,319 140,273" fill="#818CF8" fill-opacity="0.4"/>
      <polygon points="140,288 185,314 185,323 140,297" fill="#818CF8" fill-opacity="0.4"/>

      <!-- Precision cursor / pointer -->
      <polygon points="214,342 228,350 223,353 227,363 221,365 217,355 214,359" fill="#C7D2FE"/>
    </g>

    <!-- RIGHT PLATE: SHIPPED WEBAPP -->
    <g id="rightPlate">
      <polygon points="264,252 390,180 390,328 264,400" fill="url(#gradRight)"/>
      <polyline points="264,252 390,180 390,328" fill="none" stroke="#FFFFFF" stroke-width="2" stroke-opacity="0.45"/>

      <!-- App Header Bar -->
      <polygon points="280,257 372,204 372,220 280,273" fill="#0E7490" fill-opacity="0.5"/>
      <circle cx="348" cy="224" r="4.5" fill="#FFFFFF"/>
      <circle cx="360" cy="217" r="4.5" fill="#A7F3D0"/>

      <!-- Code Bracket Symbol < / > -->
      <!-- Left Angle Bracket < -->
      <polygon points="288,310 302,302 312,316 302,330 288,322 299,316" fill="#FFFFFF"/>
      <!-- Slash / -->
      <polygon points="318,328 326,323 338,299 330,304" fill="#E0F2FE"/>
      <!-- Right Angle Bracket > -->
      <polygon points="346,302 360,310 349,316 360,322 346,330 336,316" fill="#FFFFFF"/>

      <!-- Shipped Success Pill -->
      <polygon points="298,358 356,325 356,340 298,373" fill="#065F46" fill-opacity="0.8"/>
      <circle cx="312" cy="360" r="4" fill="#34D399"/>
      <polygon points="323,354 348,340 348,344 323,358" fill="#ECFDF5"/>
    </g>

    <!-- Central Node Singularity -->
    <circle cx="256" cy="246" r="6.5" fill="#FFFFFF"/>
  </g>
</svg>
"""

    # 2. HERO BANNER LOGO (WITH SLEEK DARK CONTAINER) - 820x220
    # Safe to embed in ANY environment (light mode, dark mode, docs, social preview)
    logo_banner_svg = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 820 220" width="820" height="220">
  <defs>
    <!-- Background Card Gradient -->
    <linearGradient id="bannerBg" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#0A0E1A"/>
      <stop offset="60%" stop-color="#0F172A"/>
      <stop offset="100%" stop-color="#191B33"/>
    </linearGradient>

    <!-- Gradients for Prism -->
    <linearGradient id="topG" x1="0%" y1="100%" x2="100%" y2="0%">
      <stop offset="0%" stop-color="#F59E0B"/>
      <stop offset="50%" stop-color="#F43F5E"/>
      <stop offset="100%" stop-color="#8B5CF6"/>
    </linearGradient>

    <linearGradient id="leftG" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#6366F1"/>
      <stop offset="100%" stop-color="#312E81"/>
    </linearGradient>

    <linearGradient id="rightG" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#38BDF8"/>
      <stop offset="50%" stop-color="#06B6D4"/>
      <stop offset="100%" stop-color="#10B981"/>
    </linearGradient>

    <linearGradient id="badgeG" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#F43F5E"/>
      <stop offset="50%" stop-color="#8B5CF6"/>
      <stop offset="100%" stop-color="#06B6D4"/>
    </linearGradient>

    <linearGradient id="textAppG" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#38BDF8"/>
      <stop offset="100%" stop-color="#06B6D4"/>
    </linearGradient>
  </defs>

  <!-- Container Box -->
  <rect width="820" height="220" rx="28" fill="url(#bannerBg)"/>
  <rect x="2" y="2" width="816" height="216" rx="26" fill="none" stroke="#6366F1" stroke-width="1.5" stroke-opacity="0.3"/>

  <!-- Left Prism Icon (Centered at Y=110) -->
  <g transform="translate(24, 10) scale(0.48)">
    <g transform="translate(0, 11)">
      <!-- Top Plate -->
      <polygon points="256,90 380,162 256,234 132,162" fill="url(#topG)"/>
      <polyline points="132,162 256,90 380,162" fill="none" stroke="#FFFFFF" stroke-width="3" stroke-opacity="0.5"/>
      <g transform="translate(256, 162) scale(1, 0.58)">
        <path d="M 0 -68 Q 0 0 -68 0 Q 0 0 0 68 Q 0 0 68 0 Q 0 0 0 -68 Z" fill="#FFFFFF"/>
      </g>

      <!-- Left Plate -->
      <polygon points="122,180 248,252 248,400 122,328" fill="url(#leftG)"/>
      <polyline points="122,180 248,252 248,400" fill="none" stroke="#A5B4FC" stroke-width="2.5" stroke-opacity="0.4"/>
      <polygon points="140,205 230,257 230,273 140,221" fill="#4338CA" fill-opacity="0.7"/>
      <polygon points="140,240 205,277 205,286 140,249" fill="#818CF8" fill-opacity="0.5"/>
      <polygon points="140,264 220,310 220,319 140,273" fill="#818CF8" fill-opacity="0.5"/>

      <!-- Right Plate -->
      <polygon points="264,252 390,180 390,328 264,400" fill="url(#rightG)"/>
      <polyline points="264,252 390,180 390,328" fill="none" stroke="#FFFFFF" stroke-width="2.5" stroke-opacity="0.5"/>
      <polygon points="280,257 372,204 372,220 280,273" fill="#0E7490" fill-opacity="0.6"/>
      <polygon points="288,310 302,302 312,316 302,330 288,322 299,316" fill="#FFFFFF"/>
      <polygon points="318,328 326,323 338,299 330,304" fill="#E0F2FE"/>
      <polygon points="346,302 360,310 349,316 360,322 346,330 336,316" fill="#FFFFFF"/>

      <!-- Center node -->
      <circle cx="256" cy="246" r="7" fill="#FFFFFF"/>
    </g>
  </g>

  <!-- Typography Brand Block -->
  <g transform="translate(244, 126)">
    <!-- "idea" in pure white -->
    <text x="0" y="0" font-family="system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif" font-size="74" font-weight="700" fill="#FFFFFF" letter-spacing="-1.5">idea</text>

    <!-- "2" Badge / Pill -->
    <rect x="156" y="-62" width="62" height="70" rx="16" fill="url(#badgeG)"/>
    <text x="187" y="-10" font-family="system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif" font-size="52" font-weight="900" fill="#FFFFFF" text-anchor="middle">2</text>

    <!-- "app" in cyan gradient -->
    <text x="234" y="0" font-family="system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif" font-size="74" font-weight="800" fill="url(#textAppG)" letter-spacing="-1.5">app</text>

    <!-- Tagline underneath -->
    <g transform="translate(4, 38)">
      <text font-family="system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, monospace" font-size="15" font-weight="600" letter-spacing="3.5" fill="#94A3B8">
        <tspan fill="#F59E0B">PRD</tspan>
        <tspan fill="#64748B">  /  </tspan>
        <tspan fill="#A855F7">DESIGN</tspan>
        <tspan fill="#64748B">  /  </tspan>
        <tspan fill="#38BDF8">CODE</tspan>
        <tspan fill="#64748B">  /  </tspan>
        <tspan fill="#10B981">SHIP</tspan>
      </text>
    </g>
  </g>
</svg>
"""

    # 3. TRANSPARENT DARK LOGO (FOR GITHUB DARK MODE) - 780x200
    logo_dark_transparent_svg = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 780 200" width="780" height="200">
  <defs>
    <linearGradient id="topGT" x1="0%" y1="100%" x2="100%" y2="0%">
      <stop offset="0%" stop-color="#F59E0B"/>
      <stop offset="50%" stop-color="#F43F5E"/>
      <stop offset="100%" stop-color="#8B5CF6"/>
    </linearGradient>
    <linearGradient id="leftGT" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#6366F1"/>
      <stop offset="100%" stop-color="#312E81"/>
    </linearGradient>
    <linearGradient id="rightGT" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#38BDF8"/>
      <stop offset="50%" stop-color="#06B6D4"/>
      <stop offset="100%" stop-color="#10B981"/>
    </linearGradient>
    <linearGradient id="badgeGT" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#F43F5E"/>
      <stop offset="50%" stop-color="#8B5CF6"/>
      <stop offset="100%" stop-color="#06B6D4"/>
    </linearGradient>
    <linearGradient id="textAppGT" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#38BDF8"/>
      <stop offset="100%" stop-color="#06B6D4"/>
    </linearGradient>
  </defs>

  <g transform="translate(10, 0) scale(0.48)">
    <g transform="translate(0, 11)">
      <polygon points="256,90 380,162 256,234 132,162" fill="url(#topGT)"/>
      <polyline points="132,162 256,90 380,162" fill="none" stroke="#FFFFFF" stroke-width="3" stroke-opacity="0.5"/>
      <g transform="translate(256, 162) scale(1, 0.58)">
        <path d="M 0 -68 Q 0 0 -68 0 Q 0 0 0 68 Q 0 0 68 0 Q 0 0 0 -68 Z" fill="#FFFFFF"/>
      </g>
      <polygon points="122,180 248,252 248,400 122,328" fill="url(#leftGT)"/>
      <polyline points="122,180 248,252 248,400" fill="none" stroke="#A5B4FC" stroke-width="2.5" stroke-opacity="0.4"/>
      <polygon points="140,205 230,257 230,273 140,221" fill="#4338CA" fill-opacity="0.7"/>
      <polygon points="140,240 205,277 205,286 140,249" fill="#818CF8" fill-opacity="0.5"/>
      <polygon points="140,264 220,310 220,319 140,273" fill="#818CF8" fill-opacity="0.5"/>
      <polygon points="264,252 390,180 390,328 264,400" fill="url(#rightGT)"/>
      <polyline points="264,252 390,180 390,328" fill="none" stroke="#FFFFFF" stroke-width="2.5" stroke-opacity="0.5"/>
      <polygon points="280,257 372,204 372,220 280,273" fill="#0E7490" fill-opacity="0.6"/>
      <polygon points="288,310 302,302 312,316 302,330 288,322 299,316" fill="#FFFFFF"/>
      <polygon points="318,328 326,323 338,299 330,304" fill="#E0F2FE"/>
      <polygon points="346,302 360,310 349,316 360,322 346,330 336,316" fill="#FFFFFF"/>
      <circle cx="256" cy="246" r="7" fill="#FFFFFF"/>
    </g>
  </g>

  <g transform="translate(225, 116)">
    <text x="0" y="0" font-family="system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif" font-size="74" font-weight="700" fill="#FFFFFF" letter-spacing="-1.5">idea</text>
    <rect x="156" y="-62" width="62" height="70" rx="16" fill="url(#badgeGT)"/>
    <text x="187" y="-10" font-family="system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif" font-size="52" font-weight="900" fill="#FFFFFF" text-anchor="middle">2</text>
    <text x="234" y="0" font-family="system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif" font-size="74" font-weight="800" fill="url(#textAppGT)" letter-spacing="-1.5">app</text>
    <g transform="translate(4, 38)">
      <text font-family="system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, monospace" font-size="15" font-weight="600" letter-spacing="3.5" fill="#94A3B8">
        <tspan fill="#F59E0B">PRD</tspan>
        <tspan fill="#64748B">  /  </tspan>
        <tspan fill="#A855F7">DESIGN</tspan>
        <tspan fill="#64748B">  /  </tspan>
        <tspan fill="#38BDF8">CODE</tspan>
        <tspan fill="#64748B">  /  </tspan>
        <tspan fill="#10B981">SHIP</tspan>
      </text>
    </g>
  </g>
</svg>
"""

    # 4. LIGHT LOGO (FOR GITHUB LIGHT MODE / DOCS) - 780x200
    logo_light_svg = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 780 200" width="780" height="200">
  <defs>
    <linearGradient id="topGL" x1="0%" y1="100%" x2="100%" y2="0%">
      <stop offset="0%" stop-color="#F59E0B"/>
      <stop offset="50%" stop-color="#F43F5E"/>
      <stop offset="100%" stop-color="#7C3AED"/>
    </linearGradient>
    <linearGradient id="leftGL" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#4F46E5"/>
      <stop offset="100%" stop-color="#1E1B4B"/>
    </linearGradient>
    <linearGradient id="rightGL" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#0284C7"/>
      <stop offset="50%" stop-color="#0891B2"/>
      <stop offset="100%" stop-color="#059669"/>
    </linearGradient>
    <linearGradient id="badgeGL" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#F43F5E"/>
      <stop offset="50%" stop-color="#7C3AED"/>
      <stop offset="100%" stop-color="#0284C7"/>
    </linearGradient>
  </defs>

  <g transform="translate(10, 0) scale(0.48)">
    <g transform="translate(0, 11)">
      <polygon points="256,90 380,162 256,234 132,162" fill="url(#topGL)"/>
      <polyline points="132,162 256,90 380,162" fill="none" stroke="#FFFFFF" stroke-width="3" stroke-opacity="0.6"/>
      <g transform="translate(256, 162) scale(1, 0.58)">
        <path d="M 0 -68 Q 0 0 -68 0 Q 0 0 0 68 Q 0 0 68 0 Q 0 0 0 -68 Z" fill="#FFFFFF"/>
      </g>
      <polygon points="122,180 248,252 248,400 122,328" fill="url(#leftGL)"/>
      <polyline points="122,180 248,252 248,400" fill="none" stroke="#C7D2FE" stroke-width="2.5" stroke-opacity="0.5"/>
      <polygon points="140,205 230,257 230,273 140,221" fill="#312E81" fill-opacity="0.6"/>
      <polygon points="140,240 205,277 205,286 140,249" fill="#818CF8" fill-opacity="0.6"/>
      <polygon points="140,264 220,310 220,319 140,273" fill="#818CF8" fill-opacity="0.6"/>
      <polygon points="264,252 390,180 390,328 264,400" fill="url(#rightGL)"/>
      <polyline points="264,252 390,180 390,328" fill="none" stroke="#FFFFFF" stroke-width="2.5" stroke-opacity="0.6"/>
      <polygon points="280,257 372,204 372,220 280,273" fill="#155E75" fill-opacity="0.6"/>
      <polygon points="288,310 302,302 312,316 302,330 288,322 299,316" fill="#FFFFFF"/>
      <polygon points="318,328 326,323 338,299 330,304" fill="#E0F2FE"/>
      <polygon points="346,302 360,310 349,316 360,322 346,330 336,316" fill="#FFFFFF"/>
      <circle cx="256" cy="246" r="7" fill="#FFFFFF"/>
    </g>
  </g>

  <g transform="translate(225, 116)">
    <text x="0" y="0" font-family="system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif" font-size="74" font-weight="700" fill="#0F172A" letter-spacing="-1.5">idea</text>
    <rect x="156" y="-62" width="62" height="70" rx="16" fill="url(#badgeGL)"/>
    <text x="187" y="-10" font-family="system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif" font-size="52" font-weight="900" fill="#FFFFFF" text-anchor="middle">2</text>
    <text x="234" y="0" font-family="system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif" font-size="74" font-weight="800" fill="#0284C7" letter-spacing="-1.5">app</text>
    <g transform="translate(4, 38)">
      <text font-family="system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, monospace" font-size="15" font-weight="600" letter-spacing="3.5" fill="#475569">
        <tspan fill="#D97706">PRD</tspan>
        <tspan fill="#94A3B8">  /  </tspan>
        <tspan fill="#7C3AED">DESIGN</tspan>
        <tspan fill="#94A3B8">  /  </tspan>
        <tspan fill="#0284C7">CODE</tspan>
        <tspan fill="#94A3B8">  /  </tspan>
        <tspan fill="#059669">SHIP</tspan>
      </text>
    </g>
  </g>
</svg>
"""

    # 5. FAVICON (32x32)
    favicon_svg = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" width="32" height="32">
  <rect width="32" height="32" rx="7" fill="#070A12"/>
  <polygon points="16,4 27,10.5 16,17 5,10.5" fill="#F43F5E"/>
  <polygon points="4.5,12 15,18 15,28 4.5,22" fill="#6366F1"/>
  <polygon points="17,18 27.5,12 27.5,22 17,28" fill="#06B6D4"/>
  <circle cx="16" cy="10.5" r="2.5" fill="#FFFFFF"/>
</svg>
"""

    with open("assets/logo-icon.svg", "w") as f:
        f.write(logo_icon_svg)
    with open("assets/logo.svg", "w") as f:
        f.write(logo_banner_svg)
    with open("assets/logo-dark.svg", "w") as f:
        f.write(logo_dark_transparent_svg)
    with open("assets/logo-light.svg", "w") as f:
        f.write(logo_light_svg)
    with open("assets/favicon.svg", "w") as f:
        f.write(favicon_svg)

    print("Generated all logo assets successfully!")

if __name__ == "__main__":
    create_all_assets()
