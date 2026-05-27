
ENTITY test IS
END test;

ARCHITECTURE struct OF test IS
    COMPONENT numarator IS
        GENERIC( delay: TIME := 10 ns;
                 MAX_VAL: INTEGER := 10);
        PORT(
            clock, reset, load : IN BIT;
            intrare_paralela   : IN INTEGER;
            directie           : IN BIT;   -- 1 crescator, 0 descrescator
            iesire             : OUT INTEGER;
            ovr                : OUT BIT
        );
    END COMPONENT;

    -- Semnale interne
    SIGNAL clock_s : BIT := '0'; 
    SIGNAL reset_s : BIT;
    SIGNAL load_s, directie_s : BIT;
    SIGNAL intrare_paralela_s : INTEGER := 0;
    SIGNAL iesire_s : INTEGER;
    SIGNAL ovr_s    : BIT;

    CONSTANT CLK_PERIOD : TIME := 100 ns;

BEGIN

    et1: numarator
        GENERIC MAP(
            delay   => 5 ns,   
            MAX_VAL => 10      
        )
        PORT MAP(
            clock            => clock_s,
            reset            => reset_s,
            load             => load_s,
            intrare_paralela => intrare_paralela_s,
            directie         => directie_s,
            iesire           => iesire_s,
            ovr              => ovr_s
        );

    clk_process : PROCESS
    BEGIN
        clock_s <= '0';
        WAIT FOR CLK_PERIOD / 2;
        clock_s <= '1';
        WAIT FOR CLK_PERIOD / 2; 
    END PROCESS;

    reset_s <= '0', '1' AFTER 30 ns;

   
    load_s <= '0',
              '1' AFTER 120 ns,   
              '0' AFTER 220 ns,
              '1' AFTER 420 ns,   
              '0' AFTER 520 ns;

   
    intrare_paralela_s <= 3 AFTER 130 ns,   
                          7 AFTER 430 ns;     


    directie_s <= '1',          
                  '0' AFTER 320 ns;  

END struct;
