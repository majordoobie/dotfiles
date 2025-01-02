color_list = [
    'catppuccin_mocha_rosewater="#f5e0dc"',
    'catppuccin_mocha_flamingo="#f2cdcd"',
    'catppuccin_mocha_mauve="#cba6f7"',
    'catppuccin_mocha_red="#f38ba8"',
    'catppuccin_mocha_maroon="#eba0ac"',
    'catppuccin_mocha_peach="#fab387"',
    'catppuccin_mocha_yellow="#f9e2af"',
    'catppuccin_mocha_green="#a6e3a1"',
    'catppuccin_mocha_teal="#94e2d5"',
    'catppuccin_mocha_sky="#89dceb"',
    'catppuccin_mocha_sapphire="#74c7ec"',
    'catppuccin_mocha_blue="#89b4fa"',
    'catppuccin_mocha_lavender="#b4befe"',
    'catppuccin_mocha_text="#cdd6f4"',
    'catppuccin_mocha_subtext1="#bac2de"',
    'catppuccin_mocha_subtext0="#a6adc8"',
    'catppuccin_mocha_overlay2="#9399b2"',
    'catppuccin_mocha_overlay1="#7f849c"',
    'catppuccin_mocha_overlay0="#6c7086"',
    'catppuccin_mocha_surface2="#585b70"',
    'catppuccin_mocha_surface1="#45475a"',
    'catppuccin_mocha_surface0="#313244"',
    'catppuccin_mocha_base="#1e1e2e"',
    'catppuccin_mocha_mantle="#181825"',
    'catppuccin_mocha_crust="#11111b"',
]


def rgb_to_argb(r, g, b, a=255):
    return (a << 24) | (r << 16) | (g << 8) | b


def str_to_hex(rgb_str: str) -> tuple[int, int, int]:
    # Remove the "#" at the start if it's there
    hex_color = rgb_str.lstrip('\"#').rstrip('\"')

    # Split the string into three 2-character segments and convert each to an integer
    return tuple(int(hex_color[i : i + 2], 16) for i in (0, 2, 4))


def main() -> None:
    for i in color_list:
        color_name, rgb_str = i.split("=")
        rgb_value = str_to_hex(rgb_str)
        argb_value = rgb_to_argb(*rgb_value)
        print(f"{color_name.upper()}=\"0x{argb_value:08X}\"")


if __name__ == "__main__":
    main()
