ENTITY numarator IS
    GENERIC( delay: TIME := 10 ns;
             MAX_VAL: INTEGER := 16);
    PORT(
        clock, reset: IN BIT;
        load: IN BIT;
        intrare_paralela: IN INTEGER;
        directie: IN BIT;   -- '1' = crescator, '0' = descrescator
        enable: IN BIT;    
        iesire: OUT INTEGER;
        ovr: OUT BIT
    );
END numarator;

ARCHITECTURE behave OF numarator IS
BEGIN

    PROCESS(clock, reset)
        VARIABLE temp    : INTEGER;
        VARIABLE ovr_var : BIT;
    BEGIN
        IF reset = '0' THEN
            IF directie = '1' THEN
                temp := 0;
            ELSE
                temp := MAX_VAL - 1;
            END IF;
            ovr_var := '0';
        ELSIF clock = '1' AND clock'EVENT AND clock'LAST_VALUE = '0' THEN
            IF load = '1' THEN
                temp := intrare_paralela;
                ovr_var := '0';
            ELSIF enable = '1' THEN
                IF directie = '1' THEN
                    -- Numarare crescatoare
                    IF temp = MAX_VAL - 1 THEN
                        temp := 0;
                        ovr_var := '1';
                    ELSE
                        temp := temp + 1;
                        ovr_var := '0';
                    END IF;
                ELSE
                    -- Numarare descrescatoare
                    IF temp = 0 THEN
                        temp := MAX_VAL - 1;
                        ovr_var := '1';
                    ELSE
                        temp := temp - 1;
                        ovr_var := '0';
                    END IF;
                END IF;
            END IF;
        END IF;
        iesire <= temp AFTER delay;
        ovr    <= ovr_var AFTER delay;
    END PROCESS;

END behave;
