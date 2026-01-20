const ErrorHandler = {
    getStatusMessage(status) {
        const messages = {
            429: "Too Many Requests. Please slow down.",
            419: "Your session has expired. Please refresh the page or log in again.",
            422: "Session Expired",
            405: "Session Expired",
            404: "Page Not Found",
            500: "An unknown error occurred."
        };
        return messages[status] || "Request failed";
    },
    normalizeErrorMessage(msg = '', status = null) {
        const message = msg.toString().trim().toLowerCase();
        if (!message || message.includes('unknown')) {
            return 'An unexpected error occurred. Please try again.';
        }
        if (message.includes('server error')) {
            return 'A server error occurred. Please contact support or try later.';
        }
        if (status === 419 || message.includes('csrf')) {
            return 'Your session has expired. Please refresh the page or log in again.';
        }
        return msg;
    },
    async handleErrorResponse(error, source = 'fetch') {
        const status = error?.status || error?.response?.status || 0;
        const retryAfter =
            source === 'axios'
                ? error?.response?.headers?.['retry-after']
                : error?.retryAfter || null;

        let rawMessage = error?.message || '';
        if (source === 'axios' && error.response?.data?.message) {
            rawMessage = error.response.data.message;
        }
        if (error instanceof Response) {
            try {
                const data = await error.json();
                rawMessage = data?.message || error.statusText || '';
            } catch {
                rawMessage = error.statusText || '';
            }
        }
        return {
            error: true,
            status,
            message:
                this.getStatusMessage(status) ||
                this.normalizeErrorMessage(rawMessage, status),
            ...(retryAfter && { retryAfter })
        };
    },
    async processResponseStatus(response) {
        if (response.status >= 200 && response.status < 300) {
            return response;
        }
        const error = new Error(this.getStatusMessage(response.status));
        error.status = response.status;
        if (response.status === 429) {
            error.retryAfter = response.headers.get("Retry-After");
        }
        throw error;
    },
    async jsonResponseHandler(response) {
        try {
            const data = await response.json();
            return { status: response.status, data };
        } catch {
            return {
                error: true,
                status: response.status,
                message: "Invalid server response"
            };
        }
    }
};
export default {
    doGetRequest: function(url, params) {
        return axios.get(url, { 'params': params }).then((response) => {
            return response;
        }).catch((error) => {
            return error;
        });
    },
    doPostRequest: function(url, params, config) {
        return axios.post(url, params, config).then((response) => {
            return response;
        }).catch((error) => {
            return error;
        });
    },
    doFetchRequest: function(url, actionType, payload) {
        const status = (response) => {
            if (response.status >= 200 && response.status < 300) {
                return Promise.resolve(response);
            }
            return Promise.reject(new Error(response.statusText));
        };
        const json = (response) => response.json();
        const requestOptions = {
            // mode: 'cors',
            //   credentials: 'include',
            method: "POST",
            timeout:30,
            headers: {
                "Action-Type": actionType,
                'X-CSRF-TOKEN': window.Laravel.csrfToken,
                "Content-Type": "application/json"
            },
            body: JSON.stringify(payload),
        };
        return fetch(url, requestOptions)
            .then(status)
            .then(json)
            .then((response) => {
                return response;
            }).catch((error) => {
                return error;
            });
    },
    doPutRequest: function(url, params) {
        return axios.put(url, params).then((response) => {
            return response;
        }).catch((error) => {
            return error;
        });
    },
    doPatchRequest: function(url, params) {
        return axios.patch(url, { 'params': params }).then((response) => {
            return response;
        }).catch((error) => {
            return error;
        });
    },
    doDeleteRequest: function(url, params) {
        return axios.delete(url, { 'params': params }).then((response) => {
            return response;
        }).catch((error) => {
            return error;
        });
    },
    doRequest: function(url,method, payload) {
        const status = (response) => {
            if (response.status >= 200 && response.status < 300) {
                return Promise.resolve(response);
            }
            return Promise.reject(new Error(response.statusText));
        };
        const json = (response) => response.json();
        const requestOptions = {
            method: method,
            timeout:30,
            headers: {
                'X-CSRF-TOKEN': window.Laravel.csrfToken,
                "Content-Type": "application/json"
            },
            body: JSON.stringify(payload),
        };
        return fetch(url, requestOptions)
            .then(status)
            .then(json)
            .then((response) => {
                return response;
            }).catch((error) => {
                return error;
            });
    },
    async doFetch(url, actionType, payload) {
        const options = {
            method: "POST",
            headers: {
                "Action-Type": actionType,
                "X-CSRF-TOKEN": document.querySelector('meta[name="csrf-token"]')?.getAttribute('content') || window.Laravel?.csrfToken,
                "Content-Type": "application/json"
            },
            body: JSON.stringify(payload),
        };
        try {
            const response = await fetch(url, options);
            await ErrorHandler.processResponseStatus(response);
            return await ErrorHandler.jsonResponseHandler(response);
        } catch (error) {
            return ErrorHandler.handleErrorResponse(error, 'fetch');
        }
    },

    async doHttp(url, method = 'POST', payload = {}) {
        const options = {
            method,
            headers: {
                "X-CSRF-TOKEN": document.querySelector('meta[name="csrf-token"]')?.getAttribute('content') || window.Laravel?.csrfToken,
                "Content-Type": "application/json"
            },
            body: JSON.stringify(payload),
        };
        try {
            const response = await fetch(url, options);
            await ErrorHandler.processResponseStatus(response);
            return await ErrorHandler.jsonResponseHandler(response);
        } catch (error) {
            return ErrorHandler.handleErrorResponse(error, 'fetch');
        }
    },
};
