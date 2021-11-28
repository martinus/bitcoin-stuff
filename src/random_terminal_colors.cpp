#include <algorithm>
#include <array>
#include <cstdint>
#include <iostream>

// inspired by https://github.com/s9w/oof

namespace term {

namespace detail {

static constexpr auto hsv_to_rgb(double hue, double saturation, double value) -> std::array<double, 3> {
    auto h_i = static_cast<int>(hue * 6);
    auto f = hue * 6 - h_i;
    auto p = value * (1 - saturation);
    auto q = value * (1 - f * saturation);
    auto t = value * (1 - (1 - f) * saturation);

    switch (h_i) {
    case 0:
        return {value, t, p};
    case 1:
        return {q, value, p};
    case 2:
        return {p, value, t};
    case 3:
        return {p, q, value};
    case 4:
        return {t, p, value};
    case 5:
        return {value, p, q};
    }

    throw std::runtime_error("overflow?");
}

} // namespace detail

enum class ColorType : uint8_t { foreground, background, reset };

// Changes background color
struct Color {
    uint8_t m_r{};
    uint8_t m_g{};
    uint8_t m_b{};
    ColorType m_color_type = ColorType::reset;

    // reset
    Color() = default;

    Color(ColorType ct, double r, double g, double b)
        : m_r(std::clamp<int>(r * 256, 0, 255))
        , m_g(std::clamp<int>(g * 256, 0, 255))
        , m_b(std::clamp<int>(b * 256, 0, 255))
        , m_color_type(ct) {}
};

constexpr auto operator<<(std::ostream& os, Color const& c) -> std::ostream& {
    if (ColorType::reset == c.m_color_type) {
        return os << "\x1b[0m";
    }

    char const* code = ColorType::foreground == c.m_color_type ? "\x1b[38;2;" : "\x1b[48;2;";
    return os << code << (int)c.m_r << ';' << (int)c.m_g << ';' << (int)c.m_b << 'm';
}

auto hsv_bg(double hue, double saturation, double value) -> Color {
    auto rgb = detail::hsv_to_rgb(hue, saturation, value);
    return {ColorType::background, rgb[0], rgb[1], rgb[2]};
}

auto hsv_fg(double hue, double saturation, double value) -> Color {
    auto rgb = detail::hsv_to_rgb(hue, saturation, value);
    return {ColorType::foreground, rgb[0], rgb[1], rgb[2]};
}

auto reset() -> Color {
    return {};
}

} // namespace term

// clang++ -std=c++17 -O2 random_terminal_colors.cpp
int main() {
    std::cout << term::hsv_fg(0.3, 0.7, 0.85) << "hello!" << term::reset() << " World" << std::endl;

    std::cout << "Hello World!" << std::endl;
    std::cout << "\x1b[38;2;255;255;255mTRUECOLOR\x1b[0m\n" << std::endl;
}
