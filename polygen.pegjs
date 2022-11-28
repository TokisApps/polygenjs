{
	var fs = {};
	var ns = {};
}

prg = start {return fs["S"]();}

start = (_ assignment _ start _){return null;} / 
	assignment {return null;}

assignment = _ id0:identifier _ "::=" _ 
	sts:( _  s:statement _ {return () => {return s(id0);}}) _ ";" _
    {
    	fs[id0] = sts;
	ns[id0] = 10;
        return null;
    }

identifier = xs:[a-zA-Z0-9]+ {return xs.join("");}

statement =
	a : (
    	_ id0:identifier _ {return (id) => {return fs[id0](id0);}}
    	/
    	_ "\"" xs:[^"]* "\"" _ {return (id) => {return xs.join("");}}
        /
        _ "(" _ s:statement _ ")" _ {return (id) => {return s(id);}}
    )+
    bs : (
    	_ "|" _ xy:(
    		_ id0:identifier _ {return (id) => {return fs[id0](id0);}}
    		/
    		_ "\"" xs:[^"]* "\"" _ {return (id) => {return xs.join("");}}
       		/
        	_ "(" _ s:statement _ ")" _ {return (id) => {return s(id);}}
	) _ {return (id) => {return xy(id);}}
    )* {
    	return (id)=>{
 
        	if(ns[id] <= 0) return "";
            
            if(bs.length > 0) {
            	var xyz = [];
            	xyz.push(() => {
		        	var str = "";
        		    a.forEach((x) => {str += x(id);});
                    return str;
                });
                bs.forEach((b) => {
            		xyz.push(b);
		});

		ns[id] -= 1;
            	var str = xyz[Math.round(Math.random() * (xyz.length - 1))](id);
		ns[id] += 1;
		return str;
            }else{
		   var str = "";
        	   a.forEach((x) => {str += x(id);});
                   return str;
            }
        };
    }

_ = [ \t\n]* {return () => {return "";}}


