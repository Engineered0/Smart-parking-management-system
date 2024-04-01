clear;
clc;

% Initialization of Arduino Hardware
sp = arduino('COM3', 'Uno', 'Libraries', ...
             {'ExampleLCD/LCDAddon', 'Servo'}, 'ForceBuildOn', true);

% Connection of LCD screen
DSPL = addon(sp, 'ExampleLCD/LCDAddon', 'RegisterSelectPin', 'D7', ...
             'EnablePin', 'D6', 'DataPins', {'D5', 'D4', 'D3', 'D2'});

initializeLCD(DSPL);

% Connection of RGB LED and switches
configurePin(sp, 'D12', 'DigitalOutput'); % Green light of RGB LED
configurePin(sp, 'D13', 'DigitalOutput'); % Red light of RGB LED
configurePin(sp, 'D11', 'DigitalInput');  % Exit Switch
configurePin(sp, 'D8', 'DigitalInput');   % Entry Switch

% Connection of Servo motor
configurePin(sp, 'D10', 'Servo');
srvmotor = servo(sp, 'D10');
writePosition(srvmotor, 0);
writeDigitalPin(sp, 'D13', 1);

% Initial settings
parking_slots = 13;
printLCD(DSPL, 'MATLAB Project');
pause(2);

clearLCD(DSPL);
printLCD(DSPL, 'Smart Parking Management Sys.');
pause(3);

% Displaying Welcome message on LCD
clearLCD(DSPL);
printLCD(DSPL, 'Welcome!!');
pause(2);

% Displaying Group Number message on LCD
clearLCD(DSPL);
printLCD(DSPL, 'Group 22');
pause(2);

% Displaying team member names message on LCD
clearLCD(DSPL);
printLCD(DSPL, 'Zafrin Khan');
pause(2);

clearLCD(DSPL);
printLCD(DSPL, 'Khaled Ahmed');
pause(2);

clearLCD(DSPL);
printLCD(DSPL, 'Nihal Khan');
pause(2);

% Displaying Available parking slots
clearLCD(DSPL);
printLCD(DSPL, strcat('Parking Slots:', num2str(parking_slots)));

% Main loop
while true
    % Entry loop starts
    if parking_slots > 0 && readDigitalPin(sp, 'D8') == 0
        parking_slots = parking_slots - 1;
        writePosition(srvmotor, 0.5);
        writeDigitalPin(sp, 'D13', 0);
        writeDigitalPin(sp, 'D12', 1);
        pause(2.5); % Time for which barrier arm remains open
        writePosition(srvmotor, 0);
        writeDigitalPin(sp, 'D12', 0);
        writeDigitalPin(sp, 'D13', 1);
        
        if parking_slots > 0
            clearLCD(DSPL);
            printLCD(DSPL, 'Welcome!!');
            printLCD(DSPL, strcat('Parking Slots:', num2str(parking_slots))); % Displaying updated number of available parking slots on LCD
        else
            pause(1);
            clearLCD(DSPL);
            printLCD(DSPL, 'No Empty Slots');
            printLCD(DSPL, 'Plz come later.'); % Displaying "Please Come Later" message on LCD
        end
    end

    % Exit loop starts
    if parking_slots < 13 && readDigitalPin(sp, 'D11') == 0
        parking_slots = parking_slots + 1;
        writePosition(srvmotor, 0.5);
        writeDigitalPin(sp, 'D13', 0);
        writeDigitalPin(sp, 'D12', 1);
        pause(2.5);
        writePosition(srvmotor, 0);
        writeDigitalPin(sp, 'D12', 0);
        writeDigitalPin(sp, 'D13', 1);
        clearLCD(DSPL);
        printLCD(DSPL, 'Welcome!!');
        printLCD(DSPL, strcat('Parking Slots:', num2str(parking_slots))); % Displaying updated number of available parking slots on LCD
    end
end
