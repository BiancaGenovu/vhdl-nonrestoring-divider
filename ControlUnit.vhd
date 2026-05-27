ENTITY ControlUnit IS
    GENERIC( delay: TIME := 10 ns );
    PORT(
        clock, reset: IN BIT;
        start: IN BIT;

        -- Intrari de la ExecutionUnit
        A_semn: IN BIT;
        count:  IN BIT;  

        -- Iesiri catre ExecutionUnit
        load_init: OUT BIT;
        shift_en:  OUT BIT;
        alu_load:  OUT BIT;
        alu_cmd:   OUT BIT;
        q_bit_set: OUT BIT;

        -- Iesire catre utilizator
        ready: OUT BIT
    );
END ControlUnit;

ARCHITECTURE behavioral OF ControlUnit IS

    TYPE Stare_Tip IS (
        S_IDLE,     -- astept start
        S_LOAD,     -- init A,Q
        S_SHIFT,    -- shift A:Q
        S_EXEC_OP,  -- A := A +/- M
        S_SET_Q,    -- setez bitul Q(0)
        S_CHECK,    -- verific contorul
        S_FINAL,    -- corectie finala a restului
        S_FINISH    -- revenire la IDLE
    );

    SIGNAL stare_curenta, stare_urmatoare: Stare_Tip;

BEGIN
    PROCESS(clock, reset)
    BEGIN
        IF reset = '0' THEN
            stare_curenta <= S_IDLE;
        ELSIF clock = '1' AND clock'EVENT AND clock'LAST_VALUE = '0' THEN
            stare_curenta <= stare_urmatoare; -- la fiecare clock merge mai departe
        END IF;
    END PROCESS;

    PROCESS(stare_curenta, start, A_semn, count)
    BEGIN
        -- totul pe 0 ca sa scapam de else uri
        load_init <= '0';
        shift_en  <= '0';
        alu_load  <= '0';
        alu_cmd   <= '0';   
        q_bit_set <= '0';
        ready     <= '0';

        stare_urmatoare <= stare_curenta;

        CASE stare_curenta IS

            WHEN S_IDLE =>
                ready <= '1';  
                IF start = '1' THEN
                    stare_urmatoare <= S_LOAD; -- incepem numaratoarea
                END IF;

            WHEN S_LOAD =>
                load_init <= '1'; -- faza de inceput
                stare_urmatoare <= S_SHIFT;

            WHEN S_SHIFT =>
                shift_en <= '1';  -- facem shiftarile
                stare_urmatoare <= S_EXEC_OP;

            WHEN S_EXEC_OP =>
                alu_load <= '1';      
                IF A_semn = '0' THEN
                    alu_cmd <= '1'; -- facem scadere
                ELSE
                    alu_cmd <= '0'; -- facem adunarre
                END IF;

                stare_urmatoare <= S_SET_Q;

            WHEN S_SET_Q =>
                
                IF A_semn = '0' THEN
                    q_bit_set <= '1'; -- A e pozitiv si trb pus ultimul bit pe 1
                END IF;
                stare_urmatoare <= S_CHECK;

            WHEN S_CHECK =>
    
                IF count = '1' THEN
                    stare_urmatoare <= S_FINAL;  -- am ajuns la final
                ELSE
                    stare_urmatoare <= S_SHIFT; -- mai avem de facut pasi
                END IF;

            WHEN S_FINAL =>
                
                IF A_semn = '1' THEN -- daca A e negativ mai adunam o data M, restl trb sa fie pozitiv
                    alu_load <= '1';
                    alu_cmd  <= '0';     
                END IF;

                stare_urmatoare <= S_FINISH;

            WHEN S_FINISH =>
                
                stare_urmatoare <= S_IDLE; -- gata, mergem inapoi, poate mai primim numere de impartit

        END CASE;
    END PROCESS;

END behavioral;
