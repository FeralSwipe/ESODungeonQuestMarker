# Mass Deconstructor Safe Filter

Companion safety filter for Mass Deconstructor 7.2.

Default exclusions:

- mythic (orange) items, such as the Ring of the Pale Order;
- monster sets, including Imperial City and Cyrodiil monster sets;
- weapons and shields from one/two-piece arena sets.

Gold legendary items are intentionally not protected by the quality filter.

The addon does not place permanent ESO or FCO ItemSaver locks. It intercepts only the
queue construction and the batch submitted by Mass Deconstructor, and removes protected
items from its legacy queue. Protected items are also omitted from the initial verbose list.

After installing or updating, restart ESO or run `/reloadui`. Settings are available under
**Settings -> Addons -> Mass Deconstructor Safe Filter**. `/mdsf status` prints active state.
