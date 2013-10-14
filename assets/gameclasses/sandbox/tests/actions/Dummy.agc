<?xml version="1.0" encoding="utf-8"?>
<Action>
	<Id>HelloWorld</Id>
	<Concurrency>Transient</Concurrency>
	<Scripts>
		<Script>var hworld="Hello World!";</Script>
		<Script>trace(hworld);</Script>
	</Scripts>
	<States>
		<State>
			<Id>MyActionState</Id>
			<Type>Text</Type>
			<Value>HelloDawg</Value>
		</State>
	</States>
</Action>