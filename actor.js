class Actor {
    constructor(line) {
        let parts = line.split('#');
        
        let coords = parts[1].split(',');
        let rotation = parts[2].split(',');
        
        this.name = parts[0];
        this.position = {
            x: Number.parseFloat(coords[0]),
            y: Number.parseFloat(coords[1]),
            z: Number.parseFloat(coords[2])
        }

        this.rotation = {
            x: Number.parseFloat(rotation[0]),
            y: Number.parseFloat(rotation[1]),
            z: Number.parseFloat(rotation[2])
        }

        this.health = Number.parseFloat(parts[3]);
        this.animation = parts[4];
        this.state = parts[5];
        if (parts.length > 6) {
            this.uuid = parts[6];
            this.event = parts[7];
            this.type = parts[8];
        } else {
            this.uuid = '';
            this.event = '';
            this.type = '';
        }
    }

    toString() {
        return `${this.name}#$${this.position.values().join(',')}#${this.rotation.values().join(',')}#${this.health}#${this.animation}#${this.state}#${this.uuid}#${this.event}`;
    }

    toSimpleString() {
        return `${this.name}#$${this.position.values().join(',')}#${this.rotation.values().join(',')}#${this.health}#${this.animation}#${this.state}`;
    }

    isDifferent(actor) {
        return (this.position != actor.position || 
            this.rotation != actor.rotation || 
            this.health != actor.healt || 
            this.animation != actor.animation || 
            this.state != actor.state
        );
    }
}

export { Actor }