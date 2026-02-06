# 🌑 Shadow Glass UI (Design System)

**Source**: Calculator Node (v0.1.0)
**Evolution Date**: 2026-02-06
**Characteristics**: Dark Mode, Glassmorphism, Neon Accents, Outfit Font.

## 🎨 CSS Variables (Root)
```css
:root {
    --bg-color: #0f0f13;
    --panel-bg: rgba(26, 26, 32, 0.8);
    --text-main: #ffffff;
    --text-muted: #888890;
    --accent: #7d5fff; /* Deep Purple */
    --accent-hover: #6c4bf5;
    --danger: #cf6679;
    --success: #03dac6;
    --font-main: 'Outfit', sans-serif;
}
```

## 🖼️ Core Components

### 1. Glass Panel (Container)
The signature glassmorphism effect.
```css
.glass-panel {
    background: var(--panel-bg);
    backdrop-filter: blur(20px);
    -webkit-backdrop-filter: blur(20px);
    border: 1px solid rgba(255, 255, 255, 0.05);
    border-radius: 28px;
    box-shadow: 0 24px 60px rgba(0, 0, 0, 0.5);
}
```

### 2. Neon Button
Interactive buttons with depth and hover effects.
```css
.btn {
    border: none;
    background: #25252e;
    color: var(--text-main);
    border-radius: 18px;
    cursor: pointer;
    transition: all 0.2s cubic-bezier(0.25, 0.46, 0.45, 0.94);
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.btn:hover {
    background: #32323e;
    transform: translateY(-2px);
    box-shadow: 0 8px 12px rgba(0, 0, 0, 0.2);
}

.btn:active {
    background: #3e3e4c;
    transform: translateY(1px);
}
```

### 3. Background Glow
Ambient background light.
```css
.background-glow {
    position: absolute;
    width: 600px;
    height: 600px;
    background: radial-gradient(circle, rgba(125, 95, 255, 0.15) 0%, rgba(15, 15, 19, 0) 70%);
    z-index: -1;
    pointer-events: none;
}
```
