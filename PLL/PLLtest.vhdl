lIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY PLLtest IS
PORT (
    CLK  : IN  std_logic;   -- 12 MHz
    LED1 : OUT std_logic;
    LED2 : OUT std_logic;
    LED3 : OUT std_logic;
    LED4 : OUT std_logic;
    LED5 : OUT std_logic
    );
END PLLtest;


ARCHITECTURE behaviour of PLLtest is
    SIGNAL sled : std_logic_vector(4 downto 0) := (others => '0');
    SIGNAL clk12MHz : std_logic;

    COMPONENT LEDblink IS
    PORT (
        CLK  : IN  std_logic;   -- 12 MHz
        LED1 : OUT std_logic;
        LED2 : OUT std_logic
        );
    END COMPONENT;

BEGIN

    clk12MHz <= CLK;

    LEDblink12 : LEDblink
    PORT MAP(
        CLK => clk12MHz,
        LED1 => sled(0),
        LED2 => sled(1)
            );

    LEDblink34 : LEDblink
    PORT MAP(
        CLK => clk12MHz,
        LED1 => LED3,
        LED2 => LED4
            );

    LED1 <= sled(0);
    LED2 <= sled(1);

    -- LED3 <= sled(2);
    -- LED4 <= sled(3);

    LED5 <= sled(4);

END behaviour;


