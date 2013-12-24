/** @jsx React.DOM */

var Enrollment = React.createClass({    
  render: function() {
    var css = {"Không vắng": "btn btn-success btn-sm",
              "Vắng": "btn btn-danger btn-sm",
              "Trễ": "btn btn-warning btn-sm",
              "Không học": "btn btn-primary btn-sm"};
    var plus = 'disabled';
    var minus = 'disabled';
    if (parseInt(this.props.enrollment.so_tiet_vang) < parseInt(this.props.enrollment.max) ) {plus = '';}
    if (parseInt(this.props.enrollment.so_tiet_vang) > 0) {minus = '';}
    return (
      <tr>
        <td>{this.props.stt}</td>
        <td>{this.props.enrollment.name}</td>
        <td>{this.props.enrollment.code}</td>
        <td><button onClick={this.props.on_absent}  class={css[this.props.enrollment.status]}>{'v'}</button></td>        
        <td><button onClick={this.props.on_plus} class="btn btn-default btn-sm" >+</button>{'   '}{this.props.enrollment.so_tiet_vang}{'   '}
        <button onClick={this.props.on_minus}  class="btn btn-default btn-sm"  >-</button></td>
        <td>{this.props.enrollment.phep === true ? 'Có phép' : 'Không phép'}</td>
      </tr>
    );
  }
});
var Enrollments = React.createClass({  
  handleVang: function(e,s){    
    this.props.on_vang(e,s);
  },
  render: function(){      
    var self = this;
    var enrollments = this.props.data.map(function (enrollment, i) {
      return <Enrollment stt={i} key={enrollment.id} enrollment={enrollment} on_absent={self.handleVang.bind(self,enrollment, 'vang')} on_plus={self.handleVang.bind(self,enrollment,'plus')} on_minus={self.handleVang.bind(self,enrollment,'minus')} />;
    }); 
    return (
      <div>          
        <h6>Thông tin điểm danh:</h6>
        <table class="table table-bordered table-condensed">
          <thead>
            <td>Stt</td>
            <td>Họ tên</td>
            <td>Mã sinh viên</td>
            <td>Vắng</td>        
            <td>Số tiết vắng</td>
            <td>Phép</td>  
          </thead>
          <tbody>
            {enrollments}
          </tbody>           
        </table>
      </div>
    );
  }
});

var Lich = React.createClass({    
  loadEnrollmentsFromServer: function(){    
    $.ajax({
      url: "/lich/1/enrollments.json" ,
      success: function(data) {                      
        this.setState({data: data});               
      }.bind(this)
    });    
  },
  componentWillMount: function() {
    this.loadEnrollmentsFromServer();  
  },
  getInitialState: function() {
    return {data: []};
  },    
  handleVang: function(enrollment, stat){    
    var d = {            
      stat: stat,
      lich_id: this.props.lich.id,
      enrollment: enrollment
    };    
    $.ajax({
      url: "/lich/1/enrollments",
      type: 'POST',
      data: d,
      success: function(data) {        
        this.setState({data: data});
        //alert(data.so_tiet_vang);
      }.bind(this)
    });
  },
  render: function(){      
    
    return (      
      <div>
        <h6>Thông tin buổi học</h6>
        <table class="table table-bordered">
          <thead>
            <td>Phòng</td>
            <td>Thực hành</td>
            <td>Số sinh viên có mặt</td>
            <td>Số sinh viên vắng</td>
            <td>Trạng thái</td>
          </thead>
          <tbody>
            <tr>
              <td>{this.props.lich.phong}</td>
              <td>{this.props.lich.thuc_hanh}</td>
              <td>{this.props.lich.sv_co_mat}</td>
              <td>{this.props.lich.sv_vang_mat}</td>
              <td>{this.props.lich.state}</td>
            </tr>
          </tbody>
        </table>
        <Enrollments data={this.state.data} on_vang={this.handleVang}/>
      </div>
    );    
  }
});

//var init = {"lich":{"id":1,"phong":null,"noi_dung":null,"state":"started","sv_co_mat":0,"sv_vang_mat":0,"so_tiet":3,"so_tiet_moi":3,"thuc_hanh":null},"enrollments":[{"id":1,"name":"ho1 dem1 ten1","code":"sv1","status":"Vắng","so_tiet_vang":3,"phep":null,"max":3},{"id":2,"name":"ho2 dem2 ten2","code":"sv2","status":"Vắng","so_tiet_vang":3,"phep":null,"max":3}]}

$.ajax({
      url: "/lich/1/info.json" ,
      success: function(data) {                      
        React.renderComponent(  
          <Lich lich={ENV.lich_id} lich={data} />,
          document.getElementById('main')
        );           
      }
});    


