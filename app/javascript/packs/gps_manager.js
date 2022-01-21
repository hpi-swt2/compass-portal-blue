export default class GpsManager {
    constructor() {
        this.watcherId = null;
        this.watchCallbacks = new Set()
        this.lastKnownLocation = null;
    }

    registerCallback(callback) {
        this.watchCallbacks.add(callback);
        this.startWatching();
    }

    clearCallback(callback) {
        this.watchCallbacks.delete(callback);
        if (this.watchCallbacks.size === 0) {
            this.stopWatching();
        }
    }

    clearAllCallbacks() {
        this.watchCallbacks.clear();
        this.stopWatching();
    }

    forgetLastKnownLocation() {
        this.lastKnownLocation = null;
    }

    async currentLocation() {
        return this.lastKnownLocation || await this.singleLocationRequest();
    }

    async singleLocationRequest() {
        return new Promise((resolve, reject) => {
            navigator.geolocation.getCurrentPosition(
                location => {
                    this.lastKnownLocation = location;
                    resolve(location);
                },
                error => reject(this.handleGeolocationError(error)),
            )
        });
    }

    isWatching() {
        return this.watcherId !== null;
    }

    startWatching() {
        if (this.isWatching())
            return;
        this.watcherId = navigator.geolocation.watchPosition(
            pos => {
                this.lastKnownLocation = pos;
                this.watchCallbacks.forEach(callback => callback(pos));
            },
            error => this.handleGeolocationError(error),
        );

    }

    stopWatching() {
        console.assert(this.watcherId !== null);
        navigator.geolocation.clearWatch(this.watcherId);
        this.watcherId = null;
    }

    handleGeolocationError(error) {
        console.warn(`ERROR(${error.code}): ${error.message}`);
        if (error.code === GeolocationPositionError.PERMISSION_DENIED) {
            return {
                error,
                customMesasge: "You have to grant your browser the permission to access your location if you want to use this feature."
            };
        } else {
            return {
                error,
                customMesasge: "Your browser could not determine your position. Please choose a different place."
            };
        }
    }

    async currentLocationString() {
        return GpsManager.formatLocation(await this.currentLocation());
    }

    static formatLocation(location) {
        const { coords: { latitude, longitude } } = location;
        return `${latitude},${longitude}`;
    }
}
