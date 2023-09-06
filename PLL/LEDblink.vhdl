lIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY LEDblink IS
PORT (
    CLK  : IN  std_logic;   -- 12 MHz
    LED1 : OUT std_logic;
    LED2 : OUT std_logic
    );
END LEDblink;


ARCHITECTURE behaviour of LEDblink is
    SIGNAL counter : UNSIGNED(24 downto 0);
    SIGNAL sled1 : std_logic := '0';
    SIGNAL sled2 : std_logic := '0';
BEGIN

    P1 : PROCESS( clk ) IS
    BEGIN
        if rising_edge(clk) then
            counter <= counter + 1;
            if (to_integer(counter) = 24000000) then
                counter <= (others=>'0');
                sled1 <= not sled1;
            end if;
        end if;
    END PROCESS P1;

    Pled1 : PROCESS(clk) IS
    BEGIN
        if rising_edge(clk) then
            if (to_integer(counter) = 12000000) or (counter = 0) then
                sled2 <= not sled2;
            end if;
        end if;
    END PROCESS Pled1;

    led1 <= sled1;
    led2 <= sled2;

END behaviour;


