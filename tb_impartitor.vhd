ENTITY tb_impartitor IS
END tb_impartitor;

ARCHITECTURE behavior OF tb_impartitor IS

    COMPONENT IMPARTITOR IS
        GENERIC( delay: TIME := 10 ns );
        PORT(
            clock, reset: IN BIT;
            start: IN BIT;
            
            Deimpartit_in: IN BIT_VECTOR(15 DOWNTO 0);
            Impartitor_in: IN BIT_VECTOR(15 DOWNTO 0);
            
            Cat_out: OUT BIT_VECTOR(15 DOWNTO 0);
            Rest_out: OUT BIT_VECTOR(16 DOWNTO 0);
            Gata_out: OUT BIT
        );
    END COMPONENT;

    SIGNAL clock_s : BIT := '0';
    SIGNAL reset_s : BIT := '0';
    SIGNAL start_s : BIT := '0';
    
    SIGNAL x_s : BIT_VECTOR(15 DOWNTO 0) := (others => '0'); -- deimpartit
    SIGNAL y_s : BIT_VECTOR(15 DOWNTO 0) := (others => '0'); -- impartitor
    
    SIGNAL cat_s : BIT_VECTOR(15 DOWNTO 0);
    SIGNAL rest_s : BIT_VECTOR(16 DOWNTO 0);
    SIGNAL gata_s : BIT;

    CONSTANT clk_period : TIME := 100 ns;

BEGIN

   
    DUT: IMPARTITOR
        GENERIC MAP(delay => 10 ns)
        PORT MAP(
            clock => clock_s,
            reset => reset_s,
            start => start_s,
            
            
            Deimpartit_in => x_s,
            Impartitor_in => y_s,
            
            Cat_out  => cat_s,
            Rest_out => rest_s,
            Gata_out => gata_s
        );

 
    clk_process : PROCESS
    BEGIN
        clock_s <= '0';
        WAIT FOR clk_period/2;
        clock_s <= '1';
        WAIT FOR clk_period/2;
    END PROCESS;

   
    stim_proc: PROCESS
    BEGIN		
        -- Reset initial
        reset_s <= '0'; 
        WAIT FOR 100 ns;	
        reset_s <= '1'; 
        WAIT FOR 100 ns;


        x_s <= "0000000000000111"; -- 7
        y_s <= "0000000000000011"; -- 3
        
        start_s <= '1';
        WAIT FOR clk_period;
        start_s <= '0';
        
        
        WAIT UNTIL gata_s = '1';
        WAIT FOR 200 ns;
        
       
        x_s <= "0000000010000100"; -- 45 
        y_s <= "0000000000001111"; -- 5
        
        start_s <= '1';
        WAIT FOR clk_period;
        start_s <= '0';
        
        WAIT UNTIL gata_s = '1';
        WAIT FOR 200 ns;

        WAIT;
    END PROCESS;

END behavior;
