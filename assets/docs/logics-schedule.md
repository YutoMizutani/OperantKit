# Schedule logics

## FR

Fixed ratio schedule

#### Logic

Response count

```
count >= value
```

## FI

Fixed interval schedule

#### Logic

Response time

```
time >= value
```

Response count

```
count.newValue > count.oldValue
```

## FT

Fixed time schedule

#### Logic

Response time

```
time >= value
```

## Discrete trial

Discreteable & ScheduleUseCase

####

`nextTrial()`

```
var flag: Bool

if flag ? schedule.decision() : false
```