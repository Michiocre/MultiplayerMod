/*
    Copyright (c) 2021 Kevin J. Petersen https://github.com/kevinjpetersen/
*/

#pragma once
class Shrek2Timer
{
public:
    void Start();
    void Stop();
    void Reset();

    bool IsTimerRunning();

    std::string GetTimeString();

    int TotalMilliseconds();
    int TotalSeconds();
    int TotalMinutes();
    int CurrentMilliseconds();
    int CurrentSeconds();
    int CurrentMinutes();
private:
    cxxtimer::Timer timer;
    bool IsRunning = false;
};

