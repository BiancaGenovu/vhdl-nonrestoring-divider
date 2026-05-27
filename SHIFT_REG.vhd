ENTITY SHIFT_REG IS
    GENERIC( delay: TIME := 10 ns;
             N: INTEGER := 16);
    PORT(
        clock, reset: IN BIT;
        load: IN BIT;         
        shift_en: IN BIT;      
        intrare_biti: IN BIT_VECTOR(N-1 DOWNTO 0);
        directie: IN BIT;      -- '1' = stanga, '0' = dreapta
        d_in: IN BIT;          -- ce intra
        iesire_biti: OUT BIT_VECTOR(N-1 DOWNTO 0);
        d_out: OUT BIT         -- ce iese
    );
END SHIFT_REG;

ARCHITECTURE behave OF SHIFT_REG IS
    SIGNAL reg_int : BIT_VECTOR(N-1 DOWNTO 0);
BEGIN

    PROCESS(clock, reset)
    BEGIN
        IF reset = '0' THEN
            reg_int <= (others => '0');

        ELSIF clock = '1' AND clock'EVENT AND clock'LAST_VALUE = '0' THEN
            IF load = '1' THEN
                reg_int <= intrare_biti;

            ELSIF shift_en = '1' THEN
                IF directie = '1' THEN
                    -- SHIFT STANGA
                    reg_int <= reg_int(N-2 DOWNTO 0) & d_in;
                ELSE
                    -- SHIFT DREAPTA
                    reg_int <= d_in & reg_int(N-1 DOWNTO 1);
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- iesiri
    iesire_biti <= reg_int AFTER delay;

    d_out <= reg_int(N-1) WHEN directie = '1' ELSE reg_int(0);

END behave;