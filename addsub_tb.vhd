ENTITY test IS
END test;

ARCHITECTURE tb OF test IS

    COMPONENT AddSub IS
        GENERIC (
            delay : TIME := 5 ns;
            N     : INTEGER := 16
        );
        PORT(
            op1   : IN  BIT_VECTOR(N-1 DOWNTO 0);
            op2   : IN  BIT_VECTOR(N-1 DOWNTO 0);
            cin   : IN  BIT;
            cmd   : IN  BIT;   -- 0 = adunare, 1 = scadere
            result   : OUT BIT_VECTOR(N-1 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL op1_s, op2_s : BIT_VECTOR(15 DOWNTO 0);
    SIGNAL rez_s        : BIT_VECTOR(15 DOWNTO 0);

    SIGNAL cin_s  : BIT;
    SIGNAL cmd_s  : BIT;   -- 0 = add, 1 = subtract

BEGIN

    DUT: AddSub
        GENERIC MAP (
            delay => 5 ns,
            N     => 16
        )
        PORT MAP(
            op1 => op1_s,
            op2 => op2_s,
            cin => cin_s,
            cmd => cmd_s,
            result => rez_s
        );
    
    op1_s <= X"0005",
             X"000A" AFTER 100 ns,     -- 10 + 4 = 14
             X"00FF" AFTER 200 ns,     -- 255 + 1 = overflow în biti
             X"0F0F" AFTER 300 ns,    
             X"AAAA" AFTER 400 ns;

    op2_s <= X"0003",
             X"0004" AFTER 100 ns,
             X"0001" AFTER 200 ns,
             X"00F0" AFTER 300 ns,
             X"5555" AFTER 400 ns;

 
    cin_s <= '0',
             '1' AFTER 200 ns,  
             '0' AFTER 350 ns;

    cmd_s <= '0',             
              '1' AFTER 250 ns,
              '0' AFTER 450 ns;

END tb;
