var makeBookIds = _ => copy([...Array(10).keys()].map(BookData.prototype.makeUniqueId));

var fdmLinks = (url,from,to) => {
    x=[]; 
    for(i=from;i<to;i++) 
        x.push(url.replace("*",i)); 
    y=x.join("\n");
    copy(y)
    return y;
}