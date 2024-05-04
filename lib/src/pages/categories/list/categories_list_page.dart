import 'package:cost_tracker_app/src/models/category.dart';
import 'package:cost_tracker_app/src/models/type.dart';
import 'package:cost_tracker_app/src/pages/categories/create/categories_controller.dart';
import 'package:cost_tracker_app/src/pages/categories/list/categories_list_controller.dart';
import 'package:cost_tracker_app/src/pages/home/home_controller.dart';
import 'package:cost_tracker_app/src/utils/my_colors.dart';
import 'package:cost_tracker_app/src/widgets/no_data_widget.dart';
import 'package:cost_tracker_app/src/widgets/progress_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CategoriesListPage extends StatefulWidget {
  const CategoriesListPage({Key? key}) : super(key: key);

  @override
  State<CategoriesListPage> createState() => _CategoriesListPageState() ;
}

class _CategoriesListPageState extends State<CategoriesListPage> with TickerProviderStateMixin{
  HomeController _con = new HomeController();
  CategoriesListController _conCategoryList = new CategoriesListController();
  late TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
      _conCategoryList.init(context, refresh);
      _tabController = TabController(length: _conCategoryList.types.length, vsync: this);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Realiza las inicializaciones que requieren el contexto aquí
    _con.init(context, refresh);
    _conCategoryList.init(context, refresh);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.key,
      drawer: _drawer(),
      body: DefaultTabController(
        length: _conCategoryList.types.length, // Number of tabs
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            actions: [
              _reloadAll(),
              _addCategory()
            ],
            flexibleSpace: Column(
              children: [
                SizedBox(height: 48,),
                _menuDrawer(),
                SizedBox(height: 20),
              ],
            ),
            bottom: TabBar(
              indicatorColor: MyColors.primaryColor,
              labelColor: MyColors.primaryColorDark,
              unselectedLabelColor: Colors.black,
              isScrollable: true,
              tabs: _conCategoryList.types.map((TypeTransaction type) {
                return Tab(
                  text: type.name,// The name of the tab
                );
              }).toList(),
            ),
          ),
          body: TabBarView(
            children: _conCategoryList.types.map((TypeTransaction type) {
              return FutureBuilder(
                future: _conCategoryList.getCategoriesByType(type.id!),
                builder: (context, AsyncSnapshot<List<Category>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Muestra un indicador de progreso mientras los datos se están cargando
                    return ProgressWidget(text: 'Espera un momento');
                  }
                  else if (snapshot.hasData) {
                    if (snapshot.data!.length > 0) {
                      return ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (_, index) {
                          return _contentListCategory(snapshot.data![index]);
                        },
                      );
                    } else {
                      return NoDataWidget(text: 'No hay categorias');
                    }
                  } else {
                    return NoDataWidget(text: 'No hay categorias');
                  }
                },
              );
            }).toList(),
          ),
        ),
      )
    );
  }

  Widget _contentListCategory(Category category){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            Material(
                elevation: 5.0,
                borderRadius: BorderRadius.all(Radius.circular(5)),
                child: _listCategory(category)
            )
          ],
        ),
      ),
    );
  }
  Widget _listCategory(Category category){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                      category.name!,
                      style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              fontFamily: 'NimbusSans'
                          ),
                  )
              ),
              GestureDetector(
                onTap: (){
                  _conCategoryList.delete(category.id!);
                },
                child: Icon(
                  Icons.delete_outline,
                  color: Colors.black,
                  size: 40,
                ),
              )
            ],
          )
    );
  }


  Widget _addCategory(){
    return Tooltip(
      message: 'Nueva categoría',
      child: GestureDetector(
        onTap: _con.goToCreateCategory  ,
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(right: 10,top: 8),
              child: Icon(
                Icons.add_circle_outline,
                color: Colors.black,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _reloadAll(){
    return Tooltip(
      message: 'Cargar de nuevo la pagina',
      child: GestureDetector(
        onTap: (){
          refresh();
        },
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(right: 10,top: 8),
              child: Icon(
                Icons.refresh_outlined,
                color: Colors.black,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuDrawer(){
    return GestureDetector(
      onTap: _con.openDrawer,
      child: Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(left: 20),
        child: Image.asset('assets/img/menu.png', width: 30, height: 30),
      ),
    );
  }
  Widget _drawer(){
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 300,
            child: DrawerHeader(
                decoration: BoxDecoration(
                  color: MyColors.primaryColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 190,
                      width: 300,
                      margin: EdgeInsets.only(bottom: 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50), // Ajusta el valor según el grado de redondeo que desees
                        child: Image.network(
                          _con.user?.image ?? 'https://firebasestorage.googleapis.com/v0/b/cost-tracker-app-4ee01.appspot.com/o/no-image.png?alt=media&token=fe266f62-7a4d-44dc-b1b5-5a57c1f902d1',
                          width: 200, // Ancho deseado de la imagen
                          height: 200, // Alto deseado de la imagen
                          fit: BoxFit.fitWidth, // Ajusta la imagen para que cubra todo el espacio recortado
                        ),
                      ),
                    ),
                    Text(
                      '${_con.user?.name ?? ''} ${_con.user?.lastname ?? ''}',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                      maxLines: 1,
                    ),
                    Text(
                      _con.user?.email ?? '',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[200],
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                    ),
                  ],
                )
            ),
          ),
          ListTile(
            onTap: _con.goToTransactions,
            title: Text('Realizar Transaccion'),
            trailing: Icon(Icons.attach_money_outlined),
          ),
          ListTile(
            onTap: _con.goToCategory,
            title: Text('Categorias'),
            trailing: Icon(Icons.folder_copy_outlined),
          ),
          ListTile(
            onTap: _con.goToBalance,
            title: Text('Ver balances por mes'),
            trailing: Icon(Icons.auto_graph_outlined),
          ),
          /*ListTile(
            onTap: (){},
            title: Text('Seleccionar rol'),
            trailing: Icon(Icons.person_outline),
          ),*/
          ListTile(
            onTap: _con.logout,
            title: Text('Cerrar Sesión'),
            trailing: Icon(Icons.power_settings_new),
          )
        ],
      ),
    );
  }

  void refresh(){
    setState(() {});
  }
}
