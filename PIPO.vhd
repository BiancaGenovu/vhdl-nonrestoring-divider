ENTITY PIPO IS
	GENERIC( delay: TIME := 10 ns;
		 N: INTEGER := 16);
	PORT(clock, reset, load: IN BIT;
		intrare: IN BIT_VECTOR(N-1 DOWNTO 0);
		iesire: OUT BIT_VECTOR(N-1 DOWNTO 0));
END PIPO;

ARCHITECTURE behave OF PIPO IS
    SIGNAL valoare_interna: BIT_VECTOR(N-1 DOWNTO 0);
BEGIN

    PROCESS(clock, reset)
    BEGIN
        
        IF reset='0' THEN
            valoare_interna <= (others => '0');
            
        ELSIF clock='1' AND clock'EVENT and clock'LAST_VALUE='0' THEN
            IF load='1' THEN
                valoare_interna <= intrare;
            END IF;
        END IF;
    END PROCESS;

    iesire <= valoare_interna AFTER delay;

END ARCHITECTURE behave;
