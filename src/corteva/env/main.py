from flask import Flask, request
from flask import jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow
from flask_restful import Api, Resource
from flasgger import Swagger

app = Flask(__name__)
swagger = Swagger(app)

from flasgger.utils import swag_from


#SqlAlchemy Database Configuration With Mysql
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:MmD0nuts@localhost/corteva'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['JSON_SORT_KEYS'] = False
db = SQLAlchemy(app)
ma = Marshmallow(app)
api = Api(app)

class Weather_vw(db.Model):
    weather_key = db.Column(db.Integer, primary_key=True)
    the_date = db.Column(db.Date)
    weather_station_name = db.Column(db.String(500))
    weather_station_code = db.Column(db.String(15))
    max_daily_temp = db.Column(db.Integer)
    min_daily_temp = db.Column(db.Integer)
    daily_precipitation = db.Column(db.Integer)

    def __repr__(self):
        return '<Weather_vw %s>' % self.title
    
class Weather_stat_vw(db.Model):
    weather_rollup_key = db.Column(db.Integer, primary_key=True)
    year = db.Column(db.String(6))
    weather_station_name = db.Column(db.String(500))
    weather_station_code = db.Column(db.String(15))
    avg_max_temp = db.Column(db.Float)
    avg_min_temp = db.Column(db.Float)
    tot_precipitation = db.Column(db.Float)

    def __repr__(self):
        return '<Weather_vw %s>' % self.title

class WeatherSchema(ma.Schema):
    class Meta:
        fields = ("weather_key", "the_date", "weather_station_name", "weather_station_code", 
                  "max_daily_temp", "min_daily_temp", "daily_precipitation")


class WeatherStatSchema(ma.Schema):
    class Meta:
        fields = ("weather_rollup_key", "year", "weather_station_name", "weather_station_code", 
                  "avg_max_temp", "avg_min_temp", "tot_precipitation")

weather_schema = WeatherSchema()
weathers_schema = WeatherSchema(many=True)
weatherstat_schema = WeatherStatSchema()
weatherstats_schema = WeatherStatSchema(many=True)

@app.route("/weather", methods=['GET'])
@swag_from("/Users/tim.mckean/corteva/env/api_doc_weather.yml")
def weather():
    date = request.args.get('date')
    station  = request.args.get('station', type=str)
    page = request.args.get("page", 1, type=int)
    per_page = request.args.get("per-page", 100, type=int)
    if None not in (date, station):
        weathers = Weather_vw.query.filter_by(weather_station_name = station).filter_by(the_date = date).paginate(page=page, per_page=per_page, error_out=False)
    elif date is not None:
        weathers = Weather_vw.query.filter_by(the_date = date).paginate(page=page, per_page=per_page, error_out=False)
    elif station is not None:
        weathers = Weather_vw.query.filter_by(weather_station_name = station).paginate(page=page, per_page=per_page, error_out=False)
    else:    
        weathers = Weather_vw.query.paginate(page=page, per_page=per_page, error_out=False)
    results = {
        "results": [{"date": w.the_date, "station": w.weather_station_name,
                     "max_daily_temp": w.max_daily_temp, 
                     "min_daily_temp": w.min_daily_temp,
                     "daily_precipitation": w.daily_precipitation } for w in weathers.items],
        "pagination": {
            "count": weathers.total,
            "page": page,
            "per_page": per_page,
            "pages": weathers.pages,
        },
    }
    return jsonify(results)

@app.route("/weather/stats", methods=['GET'])
@swag_from("/Users/tim.mckean/corteva/env/api_doc_weather_stat.yml")
def weatherstats():
    year = request.args.get('year')
    station  = request.args.get('station', type=str)
    page = request.args.get("page", 1, type=int)
    per_page = request.args.get("per-page", 100, type=int)
    if None not in (year, station):
        weatherstats = Weather_stat_vw.query.filter_by(weather_station_name = station).filter_by(the_date = year).paginate(page=page, per_page=per_page, error_out=False)
    elif year is not None:
        weatherstats = Weather_stat_vw.query.filter_by(the_date = year).paginate(page=page, per_page=per_page, error_out=False)
    elif station is not None:
        weatherstats = Weather_stat_vw.query.filter_by(weather_station_name = station).paginate(page=page, per_page=per_page, error_out=False)
    else:    
        weatherstats = Weather_stat_vw.query.paginate(page=page, per_page=per_page, error_out=False)
    results = {
        "results": [{"year": w.year, "station": w.weather_station_name,
                     "avg_max_temp": w.avg_max_temp, 
                     "avg_min_temp": w.avg_min_temp,
                     "tot_precipitation": w.tot_precipitation  } for w in weatherstats.items],
        "pagination": {
            "count": weatherstats.total,
            "page": page,
            "per_page": per_page,
            "pages": weatherstats.pages,
        },
    }
    return jsonify(results)


if __name__ == '__main__':
    app.run(debug=True)